App.comments = App.cable.subscriptions.create("CommentsChannel", {
  collection: function() {
    return $("[data-channel='comments']");
  },
  connected: function() {
    return setTimeout((function(_this) {
      return function() {
        _this.followCurrentMessage();
        return _this.installPageChangeCallback();
      };
    })(this), 1000);
  },
  received: function(data) {
    if (!this.userIsCurrentUser(data.comment)) {
      var collection =  this.collection().prepend(data.comment);
      return collection;
    }
  },
  userIsCurrentUser: function(comment) {
    return $(comment).attr('data-user-id') === $('meta[name=current-user]').attr('id');
  },
  followCurrentMessage: function() {
    var messageId;
    if (messageId = this.collection().data('message-id')) {
      return this.perform('follow', {
        message_id: messageId
      });
    } else {
      return this.perform('unfollow');
    }
  },
  installPageChangeCallback: function() {
    if (!this.installedPageChangeCallback) {
      this.installedPageChangeCallback = true;
      return $(document).on('turbolinks:load', function() {
        return App.comments.followCurrentMessage();
      });
    }
  }
});