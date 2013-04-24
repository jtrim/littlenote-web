require 'rack'

use Rack::Static, urls: ["/assets", "/components", "/lib"]
app = ->(env) { Rack::File.new(File.expand_path("../index.html", __FILE__)).call(env) }
run app
