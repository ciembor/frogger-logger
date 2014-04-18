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
      @channel = channel
    end

    METHODS.each do |method|
      define_method method do |msg|
        @channel.push({ method: method, content: msg }.to_json)
      end
    end
  end
end
