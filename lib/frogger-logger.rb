require 'em-websocket'
require 'json'
require 'nokogiri'
require 'frogger-logger/configuration'
require 'frogger-logger/history'
require 'frogger-logger/formatter'
require 'frogger-logger/logger'
require 'frogger-logger/dsl'
require 'frogger-logger/engine'

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
        Kernel.send(:include, FroggerLogger::DSL)
      end
      channel = EM::Channel.new
      Logger.init(channel)
      Thread.new do
        EM.run do
          EM::WebSocket.start(host: host, port: port) do |ws|
            ws.onopen do
              sid = channel.subscribe do |msg|
                ws.send msg
              end
              ws.onmessage do |message|
                message = JSON.parse(message)
                if message['status'] && 'ready' == message['status']
                  # binding.pry
                  FroggerLogger::Logger.get.send_history(message['client_id'])
                end
              end
              ws.onclose do
                channel.unsubscribe(sid)
              end
            end
          end
        end
      end
    end

    def init_request(start_time)
      client = FroggerLogger::Client.new(start_time)
      FroggerLogger::Logger.get.add_client(client)
      client.id
    end

    FroggerLogger::Logger::METHODS.each do |method|
      define_method method do |msg|
        FroggerLogger::Logger.send(method, msg)
      end
    end
  end
end

