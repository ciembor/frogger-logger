require 'spec_helper'

describe FroggerLogger::History do
  let(:history) { FroggerLogger::History.new }
  let(:since_time) { Time.now - 5 }
  let(:message) { { timestamp: since_time, method: 'method', content: 'content' } }

  describe '#<<' do
    it 'should purge old messages' do
      expect(history).to receive(:purge)
      history << message
    end

    it 'should add add message' do
      expect { history << message }.to change { history.since(since_time).count }.from(0).to(1)
    end
  end

  describe '#purge' do
    let(:very_old_since_time) { Time.now - 1000 }
    let(:message_to_purge) { { timestamp: Time.now - 601, method: 'method', content: 'content' } }

    it 'should remove messages older than 10 minutes' do
      history << message
      history << message_to_purge
      expect { history.purge }.to change { history.since(very_old_since_time).count }.from(2).to(1)
    end
  end

  describe '#since' do
    before do
      history << message
    end

    it 'should return messages with newer or the same timestamp' do
      history.since(since_time).should == [message]
    end

    it 'should not return messages older than a timestamp' do
      history.since(since_time + 1).should == []
    end
  end

  pending 'should use history_expiration_time from configuration'
end
