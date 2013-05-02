class App.Note extends Backbone.Model

  @all: ->
    c = new Backbone.Collection()
    c.url = '/notes'
    c.fetch()
    c

  url: ->
    '/notes'

  sync: (args...) ->
    debugger
    super
