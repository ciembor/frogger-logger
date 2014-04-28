var FroggerLoggerClient = function() {
};

(function() {
  var FL = FroggerLoggerClient.prototype;

  FL.availableMethods = function() {
    return ['debug', 'info', 'log', 'error', 'warn'];
  };

  FL.isMethodAvailable = function(method) {
    return this.availableMethods().indexOf(method) > -1;
  };

  FL.isMessageValid = function(message) {
    return (
      'object' === typeof message 
      && 'method' in message 
      && 'content' in message 
      && this.isMethodAvailable(message.method)
    );
  };

  FL.colors = function() {
    return {
      'debug': '#088',
      'info': '#008',
      'log': '#080',
      'error': '#800',
      'warn': '#808'
    }
  };

  FL.messageTemplate = function(message) {
    var color = this.colors()[message.method];
    var template;
    try {
      if ('object' === typeof JSON.parse(message.content)) {
        template = [
          '%c frog ', 
          'background: ' + color + '; color: #fff', 
          JSON.parse(message.content)
        ];
      } else {
        throw 'Not an object.';
      }
    } catch(e) {
      template = [
        '%c frog %c ' + message.content, 
        'background: ' + color + '; color: #fff', 
        'color: ' + color
      ];
    };
    return template;
  };

  FL.handleMessage = function(message) {
    var template;
    if (this.isMessageValid(message)) {
      template = this.messageTemplate(message);
      console[message.method](template[0], template[1], template[2]);
    } else {
      console.error('Frogger logger message is invalid! Got:', message);
    }
  };

  FL.init = function(address) {
    if ('WebSocket' in window) {
      var ws = new WebSocket(address);
      var _self = this;
      ws.onmessage = function(e) {
        _self.handleMessage(JSON.parse(e.data));
      };
      return ws;
    } else {
      console.warn("Your browser doesn't support WebSockets. Frogger logger will not log to this console.");
    }
  };
})();

(function() {
  var froggerLoggerClient = new FroggerLoggerClient;
  froggerLoggerClient.init('ws://0.0.0.0:2999');
})();

