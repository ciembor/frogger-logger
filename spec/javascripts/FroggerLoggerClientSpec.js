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

    describe(".colors()", function() {
      it("should return an object with colors assigned to method names", function() {
        var colors = subject.colors();
        expect(colors['debug']).toEqual('#088');
        expect(colors['info']).toEqual('#008');
        expect(colors['log']).toEqual('#080');
        expect(colors['error']).toEqual('#800');
        expect(colors['warn']).toEqual('#808');
      });
    });

    describe(".stringTemplate(content, color)", function() {
      it("should return template for a string", function() {
        var template = subject.stringTemplate('some content', '#123');
        expect(template).toEqual([
          '%c frog %c some content',
          'background: #123; color: #fff',
          'color: #123'
        ]);
      });
    });

    describe(".objectTemplate(content, color)", function() {
      it("should return template for an object", function() {
        var content = { "key": "value" }
        var template = subject.objectTemplate(content, '#123');
        expect(template).toEqual([
          '%c frog ',
          'background: #123; color: #fff',
          content
        ]);
      });
    });

    describe(".messageTemplate(message)", function() {
      beforeEach(function() {
        subject.colors = function() {
          return {
            'some_method': '#123'
          }
        };
      });

      it("should return template for object if content can be parsed to it", function() {
        var message = {
          "content": '{"key": "value"}',
          "method": 'some_method'
        };
        spyOn(subject, 'objectTemplate');
        subject.messageTemplate(message);
        expect(subject.objectTemplate).toHaveBeenCalledWith(JSON.parse(message.content), '#123');
      });
      it("should return template for string if it's not an object", function() {
        var message = {
          "content": 'This is not an object.',
          "method": 'some_method'
        };
        spyOn(subject, 'stringTemplate');
        subject.messageTemplate(message);
        expect(subject.stringTemplate).toHaveBeenCalledWith(message.content, '#123');
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
          spyOn(subject, 'messageTemplate').and.returnValue(['template']);
          subject.handleMessage(message);
          expect(subject.messageTemplate).toHaveBeenCalledWith(message);
          expect(console[message.method]).toHaveBeenCalledWith('template');
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
            data: '{}'
          }
          spyOn(window, 'WebSocket').and.returnValue(function() {return {onmessage: null}});
          spyOn(subject, 'handleMessage');
        });

        it("should create a WebSocket client which connects to the given address", function() {
          subject.init(address);
          expect(window.WebSocket).toHaveBeenCalledWith(address);
        });

        it("should have onmessage method overriden with a function which handles message", function() {
          ws = subject.init(address, window);
          ws.onmessage(e);
          expect(subject.handleMessage).toHaveBeenCalledWith(JSON.parse(e.data));
        });
      });

    });

  });
});
