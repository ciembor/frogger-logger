require 'frogger-logger'
require 'frogger-logger/logger'

module FroggerLogger
  module DSL
    def self.included(base)
      base.module_eval do
        def frog(message)
          FroggerLogger.log(message)
        end

        def froglog(message)
          FroggerLogger.log(message)
        end

        def frogdebug(message)
          FroggerLogger.debug(message)
        end

        def froginfo(message)
          FroggerLogger.info(message)
        end

        def frogwarn(message)
          FroggerLogger.warn(message)
        end

        def frogerr(message)
          FroggerLogger.err(message)
        end
      end
    end
  end
end
