mode     = "notes"
email    = null
password = null

statusTimeout = null
showStatus = window.showStatus = (message, persistent=false) ->
  $('#status').text(message).addClass('visible')
  clearTimeout(statusTimeout)
  unless persistent
    statusTimeout = setTimeout ->
      $('#status').removeClass('visible')
    , 3000

clearStatus = ->
  $('#status').removeClass('visible')

sendCredentials = window.sendCredentials = ->
  $.ajax({
    url: "/#{mode.split(":")[0]}"
    contentType: 'application/json'
    type: "POST"
    data: JSON.stringify({
      email: email,
      password: password
    })
  }).done( ->
    if mode.match /^register/
      showStatus "Signed up. You are now logged in."
    else if mode.match /^login/
      showStatus "Logged in."
  ).fail( (jqxhr, textStatus, errorThrown) ->
    if jqxhr.status == 422
      showStatus "Error: #{obj.responseText}", true
    else
      showStatus "Sorry, something went wrong.", true
  ).always( ->
    mode     = "notes"
    email    = null
    password = null
    $('#searchbox').removeAttr('disabled').attr('type', 'text')
  )

Mousetrap.bind 'command+shift+l', ->
  $('#searchbox').focus()

Mousetrap.bind ':', ->
  $('#searchbox').text(':').focus()

Mousetrap.bind 'esc', ->
  $('<input />')
    .appendTo('body')
    .trigger('focus')
    .css('display', 'none')
    .remove()

$('#searchbox').on 'focus', (evt) ->
  $('.search-results').show()

$('#searchbox').on 'blur', (evt) ->
  $('.search-results').hide()

$('#searchbox').on 'keyup', (evt) ->
  el = $('#search-results')[0]
  switch evt.keyCode
    when 38 # up
      el.selectedIndex = Math.max(0, el.selectedIndex - 1)
      @selectionStart = @value.length
      $(el).trigger('change')
      return
    when 40 # down
      el.selectedIndex = Math.min(el.children.length - 1, el.selectedIndex + 1)
      @selectionStart = @value.length
      $(el).trigger('change')
      return
    when 13 # enter
      if mode.match(/^(?:register|login):email/)
        email = @value
        showStatus 'Enter a password.', true
        @type = 'password'
        @value = ""
        mode = "#{mode.split(":")[0]}:password"
        return
      else if mode.match(/^(?:register|login):password/)
        password = @value
        showStatus 'Logging in...', true
        @value = ""
        @type = "text"
        $(this).attr('disabled', 'disabled')
        sendCredentials()
        return

      switch @value
        when ":register"
          showStatus 'Enter an email address.', true
          @value = ""
          mode = "register:email"
          return
        when ":login", ":signin", ":log_in", ":sign_in"
          showStatus 'Enter an email address.', true
          @value = ""
          mode = "login:email"
          return
      currentValue = if _.isEmpty(el.value) then @value else el.value
      $('#editor').attr('data-current-note', currentValue)
      $('#editor').text(notes[currentValue] || '')
      Mousetrap.trigger('esc')
      $('#editor').trigger('focus')
      el = document.getElementById("editor")
      if el.childNodes.length
        range = document.createRange()
        sel = window.getSelection()
        range.setStart(el.childNodes[0], el.innerText.length)
        range.collapse(true)
        sel.removeAllRanges()
        sel.addRange(range)
      return

  matchedKeys = _.select _.keys(notes), (key) =>
    key.match(new RegExp(@value))

  $(el).empty()

  _.each matchedKeys.sort(), (key) =>
    $(el).append "<option value='#{key}'>#{key}</option>"

$('#editor').on 'keyup', ->
  notes[$(this).attr('data-current-note')] = this.innerText
  localStorage.setItem('littlenotes', JSON.stringify(notes))
