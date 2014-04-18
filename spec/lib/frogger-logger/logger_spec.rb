require 'spec_helper'

describe FroggerLogger::Logger do
  describe '.init' do
    it 'initializes logger singleton' do
      described_class.get.should be_nil
      described_class.init(nil)
      described_class.get.should_not be_nil
    end
  end

  describe '.log' do
    let (:logger) { double }

    before do
      described_class.stub(:get) { logger }
    end

    it 'delegates logging to singleton instance' do
      logger.should_receive(:log).with("hello!")
      described_class.log("hello!")
    end
  end


  [:debug, :log, :info, :warn, :error].each do |method|
    describe method do
      let (:channel) { double }

      it 'pushes message json to injected channel' do
        channel.should_receive(:push).with({ method: method, content: "hello!" }.to_json)
        described_class.new(channel).send(method, "hello!")
      end
    end
  end
end
