describe("FroggerLoggerClient", function() {

  describe(".prototype", function() {
    beforeEach(function() {
      subject = FroggerLoggerClient.prototype;
    });

    describe(".availableMethods()", function() {
      it("should contain all available methods", function() {
        var methods = subject.availableMethods();
        expect(methods).toContain('debug');
        expect(methods).toContain('info');
        expect(methods).toContain('log');
        expect(methods).toContain('error');
        expect(methods).toContain('warn');
      });

      it("should not contain other methods", function() {
        var methods = subject.availableMethods();
        expect(methods.length).toBe(5);
      });
    });

    describe(".isMethodAvailable(method)", function() {
      beforeEach(function() {
        spyOn(subject, 'availableMethods').and.returnValue([
          'someMethod',
          'availableMethod',
          'anotherMethod' 
        ]);
      });

      it("should return true if method is available", function() {
        expect(subject.isMethodAvailable('availableMethod')).toBeTruthy();
      });

      it("should return false if method is not available", function() {
        expect(subject.isMethodAvailable('notAvailableMethod')).toBeFalsy();
      });
    });

    describe(".isMessageValid(message)", function() {
      describe("method is available", function() {
        beforeEach(function() {
          spyOn(subject, 'isMethodAvailable').and.returnValue(true);
        });

        it("should return true if message is valid", function() {
          expect(subject.isMessageValid({
            method: 'availableMethod',
            content: 'validContent'
          })).toBeTruthy();
        });

        it("should return false if message has no method", function() {
          expect(subject.isMessageValid({
            content: 'validContent'
          })).toBeFalsy();
        });

        it("should return false if message has no content", function() {
          expect(subject.isMessageValid({
            method: 'availableMethod'
          })).toBeFalsy();
        });

        it("should return false if message is not an object", function() {
          expect(subject.isMessageValid("notObject")).toBeFalsy();
        });
      });

      describe("method is not available", function() {
        beforeEach(function() {
          spyOn(subject, 'isMethodAvailable').and.returnValue(false);
        });

        it("should return false if method is not available", function() {
          expect(subject.isMessageValid({
            method: 'availableMethod',
            content: 'validContent'
          })).toBeFalsy();
        });

      });
    });

    describe(".handleMessage(message)", function() {
      beforeEach(function() {
        message = { method: 'someMethod', content: 'someContent' };
        console = {};
        console[message.method] = function(content) {};
        console.error = function(content, detail) {};
      });

      describe("method is valid", function() {
        beforeEach(function() {
          spyOn(subject, 'isMessageValid').and.returnValue(true);
          spyOn(console, message.method);
        });

        it("should log content to the console using correct method", function() {
          subject.handleMessage(message);
          expect(console[message.method]).toHaveBeenCalledWith(message.content);
        });
      });

      describe("method is invalid", function() {
        beforeEach(function() {
          spyOn(subject, 'isMessageValid').and.returnValue(false);
          spyOn(console, 'error');
        });

        it("should log error with datails", function() {
          subject.handleMessage(message);
          expect(console.error).toHaveBeenCalledWith('Frogger logger message is invalid! Got:', message);
        });
      });

      describe(".init(address, window)", function() {
        beforeEach(function() {
          address = 'ws://test.address';
          window = {};
          e = {
            data: {}
          }
          spyOn(window, 'WebSocket').and.returnValue(function() {return {onmessage: null}});
          spyOn(subject, 'handleMessage');
        });

        it("should create a WebSocket client which connects to the given address", function() {
          subject.init(address);
          expect(window.WebSocket).toHaveBeenCalledWith(address);
        });

        xit("should have onmessage method overriden with a function which handles message", function() {
          ws = subject.init(address, window);
          ws.onmessage(e);
          expect(subject.handleMessage).toHaveBeenCalledWith(e.data);
        });
      });

    });

  });
});
