require 'json'
module FroggerLogger
  class Logger
    def self.init(channel)
      @logger = new(channel)
    end

    def self.get
      @logger
    end

    def self.log(message)
      get.log(message)
    end

    def initialize(channel)
      @channel = channel
    end

    def log(message)
      @channel.push({ method: :log, content: message }.to_json)
    end
  end
end
