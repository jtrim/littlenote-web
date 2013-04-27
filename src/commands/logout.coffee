class App.LogoutCommand extends App.Command

  initialize: ->
    $.ajax({
      url: "/logout"
      contentType: 'application/json'
      type: "DELETE"
    }).done( =>
      App.StatusBar.show "Logged out."
    ).fail( (jqxhr) ->
      App.StatusBar.show "Sorry, something went wrong.", true
    ).always( =>
      @tearDown()
    )

