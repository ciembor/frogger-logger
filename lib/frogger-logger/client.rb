require 'securerandom'

module FroggerLogger
  class Client
    attr_reader :id
    attr_reader :start_time

    def initialize(start_time)
      @start_time = start_time
      @id = SecureRandom.uuid
    end

    def history(full_history)
      messages = full_history.since(start_time) if start_time
      messages.map { |message| message.merge({ client_id: id }) }
    end
  end
end