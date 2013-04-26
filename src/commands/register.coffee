class App.RegisterCommand extends Backbone.View

  mode: 'email'

  constructor: (searchbox) ->
    @searchbox = searchbox
    super el: @searchbox.el

  initialize: ->
    @searchbox.undelegateEvents()
    @searchbox.$el.val ''
    App.StatusBar.show "Enter your email"

  events:
    "keyup": "onKeyUp"

  onKeyUp: (event) ->
    return unless @wasEnterKey(event)
    switch @mode
      when "email"
        App.StatusBar.show "Enter a password"
        @email = @$el.val()
        @mode = "password"
        @$el.val('')
        @$el.attr('type', 'password')
      when "password"
        @password = @$el.val()
        @$el.val('')
        @$el.attr('type', 'text')
        @submitRegistration()

  submitRegistration: ->
    $.ajax({
      url: "/register"
      contentType: 'application/json'
      type: "POST"
      data: JSON.stringify({
        email: @email
        password: @password
      })
    }).done( ->
      App.StatusBar.show "Signed up. You are now logged in."
    ).fail( (jqxhr) ->
      if jqxhr.status == 422
        App.StatusBar.show "Error: #{jqxhr.responseText}", true
      else
        App.StatusBar.show "Sorry, something went wrong.", true
    ).always( =>
      @undelegateEvents()
      @searchbox.delegateEvents()
    )

  wasEnterKey: (event) ->
    event.keyCode == 13
