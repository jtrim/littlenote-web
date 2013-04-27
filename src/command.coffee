class App.Command extends Backbone.View

  constructor: (searchbox) ->
    @searchbox = searchbox
    super el: @searchbox.el

  initialize: ->
    @searchbox.undelegateEvents()
    @searchbox.$el.val ''
    App.StatusBar.show "Enter your email"
    $(document).on 'littlenote:escape', =>
      App.StatusBar.clear()
      @tearDown()

  events:
    "keyup": "onKeyPress"

  onKeyPress: (event) ->
    if @wasEnterKey(event)
      @return()

  wasEnterKey: (event) ->
    event.keyCode == 13

  tearDown: ->
    @undelegateEvents()
    @searchbox.delegateEvents()
    @$el.val('')
    @$el.attr('type', 'text')
