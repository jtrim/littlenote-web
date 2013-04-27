// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.SearchBox = (function(_super) {

    __extends(SearchBox, _super);

    function SearchBox() {
      return SearchBox.__super__.constructor.apply(this, arguments);
    }

    SearchBox.prototype.el = "#searchbox";

    SearchBox.prototype.events = {
      "keyup": "onKeyUp"
    };

    SearchBox.prototype.initialize = function() {
      var _this = this;
      Mousetrap.bind('command+shift+l', function() {
        return _this.$el.focus();
      });
      Mousetrap.bind(':', function() {
        return _this.$el.text(':').focus();
      });
      return Mousetrap.bind('esc', function() {
        _this.blur();
        return $(document).trigger("littlenote:escape");
      });
    };

    SearchBox.prototype.onKeyUp = function(event) {
      if (!this.wasEnterKey(event)) {
        return;
      }
      switch (this.el.value) {
        case ":register":
          return new App.RegisterCommand(this);
        case ":login":
          return new App.LoginCommand(this);
        case ":logout":
          return new App.LogoutCommand(this);
      }
    };

    SearchBox.prototype.blur = function() {
      return $('<input />').appendTo('body').trigger('focus').css('display', 'none').remove();
    };

    SearchBox.prototype.wasEnterKey = function(event) {
      return event.keyCode === 13;
    };

    return SearchBox;

  })(Backbone.View);

}).call(this);
