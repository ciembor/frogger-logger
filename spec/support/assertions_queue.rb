class AssertionsQueue
  TIMEOUT = 0.1
  def initialize(queue)
    @queue = queue
  end

  def expect_message(message)
    Timeout::timeout(TIMEOUT) do
      @queue.pop.data.should == message
    end
  end
end
