// Generated by CoffeeScript 1.3.3
(function() {
  var notes;

  notes = JSON.parse(localStorage.getItem('littlenotes')) || {};

  Mousetrap.bind('command+shift+l', function() {
    return $('#searchbox').focus();
  });

  Mousetrap.bind('esc', function() {
    return $('<input />').appendTo('body').trigger('focus').css('display', 'none').remove();
  });

  $('#searchbox').on('focus', function(evt) {
    return $('.search-results').show();
  });

  $('#searchbox').on('blur', function(evt) {
    return $('.search-results').hide();
  });

  Mousetrap.bind('} }', function() {
    var el, range, sel;
    el = document.getElementById("#editor");
    range = document.createRange();
    sel = window.getSelection();
    range.setStart(el.childNodes[0], el.innerText.length);
    range.collapse(true);
    sel.removeAllRanges();
    return sel.addRange(range);
  });

  $('#searchbox').on('keyup', function(evt) {
    var currentValue, el, matchedKeys, range, sel,
      _this = this;
    el = $('#search-results')[0];
    switch (evt.keyCode) {
      case 38:
        el.selectedIndex = Math.max(0, el.selectedIndex - 1);
        this.selectionStart = this.value.length;
        $(el).trigger('change');
        return;
      case 40:
        el.selectedIndex = Math.min(el.children.length - 1, el.selectedIndex + 1);
        this.selectionStart = this.value.length;
        $(el).trigger('change');
        return;
      case 13:
        currentValue = _.isEmpty(el.value) ? this.value : el.value;
        $('#editor').attr('data-current-note', currentValue);
        $('#editor').text(notes[currentValue] || '');
        Mousetrap.trigger('esc');
        $('#editor').trigger('focus');
        el = document.getElementById("editor");
        if (el.childNodes.length) {
          range = document.createRange();
          sel = window.getSelection();
          range.setStart(el.childNodes[0], el.innerText.length);
          range.collapse(true);
          sel.removeAllRanges();
          sel.addRange(range);
        }
        return;
    }
    matchedKeys = _.select(_.keys(notes), function(key) {
      return key.match(new RegExp(_this.value));
    });
    $(el).empty();
    return _.each(matchedKeys.sort(), function(key) {
      return $(el).append("<option value='" + key + "'>" + key + "</option>");
    });
  });

  $('#editor').on('keyup', function() {
    notes[$(this).attr('data-current-note')] = this.innerText;
    return localStorage.setItem('littlenotes', JSON.stringify(notes));
  });

}).call(this);
