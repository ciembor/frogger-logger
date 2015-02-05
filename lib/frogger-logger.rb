require 'em-websocket'
require 'json'
require 'nokogiri'
require 'frogger-logger/configuration'
require 'frogger-logger/history'
require 'frogger-logger/formatter'
require 'frogger-logger/logger'
require 'frogger-logger/dsl'
require 'frogger-logger/engine'
require 'frogger-logger/server'
require 'frogger-logger/client'


module FroggerLogger

  EXTEND_WITH_DSL = true

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def init(host = configuration.host, port = configuration.port)
      if configuration.extend_with_dsl
        Kernel.send(:include, DSL)
      end
      Server.new(host, port)
    end

    def init_request(start_time)
      client = Client.new(start_time)
      Logger.get.add_client(client)
      client.id
    end

    Logger::METHODS.each do |method|
      define_method method do |msg|
        Logger.send(method, msg)
      end
    end
  end
end

