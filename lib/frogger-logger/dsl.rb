require 'frogger-logger'
require 'frogger-logger/logger'

module FroggerLogger
  module DSL
    def self.included(base)
      base.module_eval do
        def frog(message)
          FroggerLogger.log(message)
        end
      end
    end
  end
end
