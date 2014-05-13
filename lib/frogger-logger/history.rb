module FroggerLogger
  class History

    EXPIRATION_TIME_IN_SECONDS = 600

    def initialize()
      @messages = []
    end

    def <<(message)
      purge
      @messages << message
    end

    def purge
      @messages.reject! { |message| purge_time?(message[:timestamp]) }
    end

    def since(timestamp)
      @messages.select { |message| newer_than?(message, timestamp) }
    end

    private

    def purge_time?(timestamp)
      timestamp < Time.at(Time.now - Time.at(EXPIRATION_TIME_IN_SECONDS))
    end

    def newer_than?(message, timestamp)
      timestamp <= message[:timestamp]
    end

  end
end
