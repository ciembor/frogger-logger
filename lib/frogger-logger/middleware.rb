require 'frogger-logger'

module FroggerLogger
  class Middleware
    def initialize(app)
      @app = app
      FroggerLogger.init
    end

    def call(env)      
      @app.call(env)   
    end   
  end
end