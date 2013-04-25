require 'pry'
require 'json'
require 'rack/cache'
require 'sinatra'
require 'digest/sha1'
require 'redis'

use Rack::Static, urls: ["/assets", "/components", "/lib"]
use Rack::Cache
set :static_cache_control, :public
enable :sessions

REDIS = Redis.new

def validate_registration(email, password)
  errors = {}
  unless email =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
    errors["email"] = "is not valid"
  end

  if errors.keys.empty?
    if REDIS.get(email_key(email))
      errors["email"] = "has already been taken"
      return errors
    end
  end

  unless password.length >= 7
    errors["password"] = "must be at least 7 characters"
  end

  !errors.keys.empty? ? errors : nil
end

def validate_login(email, password)
  errors = {}
  if email.empty?
    errors["email"] = "must be present"
  end

  user = REDIS.get(email_key(email))
  unless user
    errors["email"] = "not found"
  end

  if user
    user = JSON.parse(user)

    hashed_incoming_password = hashed_password(password, user["salt"])
    if hashed_incoming_password != user["password"]
      errors["password"] = "is incorrect"
    end
  end

  !errors.keys.empty? ? errors : nil
end

def hashed_password(password, salt)
  Digest::SHA1.hexdigest "#{salt}#{password}"
end

def email_key(email)
  "littlenote:#{email}"
end

before /\/register|\/login/ do
  request.body.rewind
  @params.merge! JSON.parse(request.body.read)
end

get '/' do
  if !defined?(@index_html) || !@index_html
    puts "Setting html in mem"
    @index_html = File.read(File.expand_path("../index.html", __FILE__))
  end
  etag Digest::SHA1.hexdigest(@index_html)
  @index_html
end

post '/register' do
  content_type 'application/json'
  # validate params
  email    = params["email"]
  password = params["password"]

  if errors = validate_registration(email, password)
    status 422
    {errors: errors}.to_json
  else
    salt = Digest::SHA1.hexdigest(Time.now.to_i.to_s)
    salted_password_hash = hashed_password(password, salt)
    user = { "key" => email_key(email), "salt" => salt, "password" => salted_password_hash, "notes" => "{}" }
    REDIS.set(email_key(email), user.to_json)
    user.delete("notes")
    session[:current_user] = user
    '{"ok":"ok"}'
  end
end

post '/login' do
  content_type 'application/json'
  # validate params
  email    = params["email"]
  password = params["password"]

  if errors = validate_login(email, password)
    status 422
    {errors: errors}.to_json
  else
    # Don't want to store notes in the session
    user = JSON.parse(REDIS.get(email_key(email)))
    user.delete("notes")
    session[:current_user] = user
    '{"ok":"ok"}'
  end
end

delete '/logout' do
  session.delete(:current_user)
  redirect to('/')
end

get '/notes' do
  content_type 'application/json'
  halt 403 unless session[:current_user]
  JSON.parse(REDIS.get(session[:current_user]["key"]))["notes"] # notes is stored as JSON
end

patch '/notes' do
  content_type 'application/json'
  halt 403 unless session[:current_user]
  request.body.rewind
  incoming_notes = JSON.parse(request.body.read)
  from_redis = JSON.parse(REDIS.get(session[:current_user]["key"]))
  notes = JSON.parse(from_redis["notes"])
  notes.merge! incoming_notes
  from_redis["notes"] = notes.to_json
  REDIS.set(from_redis["key"], from_redis.to_json)
  '{"ok":"ok"}'
end
