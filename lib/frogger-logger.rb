require 'em-websocket'
require 'frogger-logger/logger'
require 'frogger-logger/dsl'

module FroggerLogger

  EXTEND_WITH_DSL = true

  class << self
    def init(host = "0.0.0.0", port = 8080)
      channel = EM::Channel.new
      Logger.init(channel)
      Thread.new do
        EM.run do
          EM::WebSocket.start(host: host, port: port) do |ws|
            ws.onopen do
              sid = channel.subscribe do |msg|
                ws.send msg
              end
              ws.onclose do
                channel.unsubscribe(sid)
              end
            end
          end
        end
      end
    end

    FroggerLogger::Logger::METHODS.each do |method|
      define_method method do |msg|
        FroggerLogger::Logger.send(method, msg)
      end
    end

    if EXTEND_WITH_DSL
      Kernel.send(:include, FroggerLogger::DSL)
    end
  end
end

