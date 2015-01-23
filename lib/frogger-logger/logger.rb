require 'frogger-logger'
require 'json'

module FroggerLogger
  class Logger

    METHODS = [:debug, :log, :info, :warn, :error]

    class << self
      def init(channel)
        @logger = new(channel)
      end

      def get
        @logger
      end

      METHODS.each do |method|
        define_method method do |msg|
          get.send(method, msg)
        end
      end
    end

    def initialize(channel)
      @formatter = FroggerLogger::Formatter.new(FroggerLogger.configuration.json_format)
      @history = FroggerLogger::History.new
      @channel = channel
    end

    METHODS.each do |method|
      define_method method do |content|
        message = { method: method, content: @formatter.format(content) }
        @history << message.merge({ timestamp: Time.now })
        @channel.push(message.to_json)
      end
    end
  end
end
