require 'frogger-logger'
require 'support/dummy_client'
require 'support/assertions_queue'

module ClientExpectations
  PORT = 3127
  HOSTNAME = "0.0.0.0"

  def with_running_client(&block)
    FroggerLogger.init(HOSTNAME, PORT)
    client = DummyClient.new(HOSTNAME, PORT)
    client.run(&block)
    AssertionsQueue.new(client.message_queue)
  end
end
