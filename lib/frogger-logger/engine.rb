require 'frogger-logger'
require 'frogger-logger/middleware'

if defined? Rails
  module FroggerLogger
    module Rails
      class Engine < ::Rails::Engine
        initializer "frogger_logger.run_server" do
          ::Rails.application.middleware.use FroggerLogger::Middleware
        end
      end
    end
  end
end