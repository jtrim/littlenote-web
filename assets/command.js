// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Command = (function(_super) {

    __extends(Command, _super);

    function Command(searchbox) {
      this.searchbox = searchbox;
      Command.__super__.constructor.call(this, {
        el: this.searchbox.el
      });
    }

    Command.prototype.initialize = function() {
      var _this = this;
      this.searchbox.undelegateEvents();
      this.searchbox.$el.val('');
      App.StatusBar.show("Enter your email");
      return $(document).on('littlenote:escape', function() {
        App.StatusBar.clear();
        return _this.tearDown();
      });
    };

    Command.prototype.events = {
      "keyup": "onKeyPress"
    };

    Command.prototype.onKeyPress = function(event) {
      if (this.wasEnterKey(event)) {
        return this["return"]();
      }
    };

    Command.prototype.wasEnterKey = function(event) {
      return event.keyCode === 13;
    };

    Command.prototype.tearDown = function() {
      this.undelegateEvents();
      this.searchbox.delegateEvents();
      this.$el.val('');
      return this.$el.attr('type', 'text');
    };

    return Command;

  })(Backbone.View);

}).call(this);