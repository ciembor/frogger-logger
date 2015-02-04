require 'frogger-logger'
require 'frogger-logger/client'
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
      @new_clients = []
      @channel = channel
    end

    def add_client(client)
      @new_clients << client
    end

    def get_client_by_id(client_id)
      @new_clients.select { |client| client.id == client_id }.first
    end

    def remove_client(client)
      @new_clients -= [client]
    end

    def send_history(client_id)
      if (client = get_client_by_id(client_id))
        client.history(@history).each { |message| send_message(message) }
        remove_client(client)
      end
    end

    def add_to_history(message)
      @history << message.merge({ timestamp: Time.now })
    end

    def send_message(message)
      @channel.push(message.to_json)
    end

    METHODS.each do |method|
      define_method method do |content|
        message = { method: method, content: @formatter.format(content) }
        add_to_history(message)     
        send_message(message)
      end
    end
  end
end
