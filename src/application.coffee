# Mousetrap bindings
#
notes = JSON.parse(localStorage.getItem('littlenotes')) || {}

Mousetrap.bind 'command+shift+l', ->
  $('#searchbox').focus()

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

Mousetrap.bind '} }', ->
  el = document.getElementById("#editor")
  range = document.createRange()
  sel = window.getSelection()
  range.setStart(el.childNodes[0], el.innerText.length)
  range.collapse(true)
  sel.removeAllRanges()
  sel.addRange(range)

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
