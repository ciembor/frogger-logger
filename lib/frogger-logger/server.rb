module FroggerLogger
  class Server
    def initialize(host, port)
      channel = EM::Channel.new
      FroggerLogger::Logger.init(channel)
      Thread.new do
        EM.run do
          EM::WebSocket.start(host: host, port: port) do |ws|
            ws.onopen { on_open(ws, channel) }
            ws.onmessage { |msg| on_message(msg) }
          end
        end
      end
    end

    private

    def on_open(ws, channel)
      sid = channel.subscribe do |msg|
        ws.send msg
      end
      ws.onclose do
        channel.unsubscribe(sid)
      end
    end

    def on_message(msg)
      msg = JSON.parse(msg)
      if msg['status'] && 'ready' == msg['status']
        logger = FroggerLogger::Logger.get
        logger.send_history(msg['client_id'])
      end
    end
  end
end