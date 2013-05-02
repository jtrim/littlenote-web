class App.SearchBox extends Backbone.View

  el: "#searchbox"

  events:
    "keyup": "onKeyUp"

  initialize: ->
    Mousetrap.bind 'command+shift+l', => @$el.focus()
    Mousetrap.bind ':', => @$el.text(':').focus()
    Mousetrap.bind 'esc', =>
      @blur()
      $(document).trigger("littlenote:escape")

  onKeyUp: (event) ->
    if @wasEnterKey(event)
      switch @el.value
        when ":register" then new App.RegisterCommand(this)
        when ":login" then new App.LoginCommand(this)
        when ":logout" then new App.LogoutCommand(this)
    else
      console.log @el.value

  blur: ->
    $('<input />')
      .appendTo('body')
      .trigger('focus')
      .css('display', 'none')
      .remove()

  wasEnterKey: (event) ->
    event.keyCode == 13
