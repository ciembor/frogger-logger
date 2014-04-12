var FroggerLoggerClient = function() {
};

FroggerLoggerClient.prototype.availableMethods = function() {
  return ['debug', 'info', 'log', 'error', 'warn'];
}

FroggerLoggerClient.prototype.isMethodAvailable = function(method) {
  return this.availableMethods().indexOf(method) > -1;
}

FroggerLoggerClient.prototype.isMessageValid = function(message) {
  return (
    'object' === typeof message 
    && 'method' in message 
    && 'content' in message 
    && this.isMethodAvailable(message.method)
  );
}

FroggerLoggerClient.prototype.handleMessage = function(message) {
  if (this.isMessageValid(message)) {
    console[message.method](message.content);
  } else {
    console.error('Frogger logger message is invalid! Got:', message);
  }
};

FroggerLoggerClient.prototype.init = function(address, window) {
  if ('WebSocket' in window) {
    var ws = new WebSocket(address);
    ws.onmessage = function(e) {
      this.handleMessage(e.data);
    };
  } else {
    console.warn("Your browser doesn't support WebSockets. Frogger logger will not log to this console.");
  }
};
