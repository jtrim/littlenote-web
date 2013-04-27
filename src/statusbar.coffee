class App.StatusBar extends Backbone.View

  el: "#status"

  @clear: ->
    @status.$el.removeClass('visible')

  @show: (message, persistent=false) ->
    @status ||= new this()
    @status.$el.text(message).addClass('visible')
    clearTimeout(@statusTimeout)
    unless persistent
      @statusTimeout = setTimeout =>
        @status.$el.removeClass('visible')
      , 3000
