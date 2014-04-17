require 'spec_helper'
require 'em-websocket-client'

class DummyClient
  attr_reader :message_queue

  def initialize(host = "0.0.0.0", port = 8080)
    @host = host
    @port = port
    @message_queue = Queue.new
    @connected = false
  end

  def run
    sleep(0.1)
    EM.next_tick do
      connection = EM::WebSocketClient.connect("ws://#{@host}:#{@port}")
      connection.callback do
        yield
      end
      connection.stream do |msg|
        @message_queue << msg
      end
    end
  end
end
