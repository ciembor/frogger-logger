var FroggerLoggerClient = function() {
};

(function() {
  var FL = FroggerLoggerClient.prototype;

  FL.availableMethods = function() {
    return ['debug', 'info', 'log', 'error', 'warn'];
  }

  FL.isMethodAvailable = function(method) {
    return this.availableMethods().indexOf(method) > -1;
  }

  FL.isMessageValid = function(message) {
    return (
      'object' === typeof message 
      && 'method' in message 
      && 'content' in message 
      && this.isMethodAvailable(message.method)
    );
  }

  FL.handleMessage = function(message) {
    if (this.isMessageValid(message)) {
      console[message.method](message.content);
    } else {
      console.error('Frogger logger message is invalid! Got:', message);
    }
  };

  FL.init = function(address) {
    if ('WebSocket' in window) {
      var ws = new WebSocket(address);
      var _self = this;
      ws.onmessage = function(e) {
        _self.handleMessage(e.data);
      };
      return ws;
    } else {
      console.warn("Your browser doesn't support WebSockets. Frogger logger will not log to this console.");
    }
  };
})();
