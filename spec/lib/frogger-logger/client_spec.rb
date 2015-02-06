require 'spec_helper'

describe FroggerLogger::Client do
  let(:start_time) { Time.now }
  let(:client) { FroggerLogger::Client.new(start_time) }

  describe '#id' do
    let(:client2) { FroggerLogger::Client.new(Time.now) }

    it 'should be uuid' do
      expect(client.id).not_to eq client2.id
    end
  end

  describe '#start_time' do
    it 'should be uuid' do
      expect(client.start_time).to eq start_time
    end
  end

  describe '#history' do
    let(:new_message) { { timestamp: Time.now } }
    let(:second_new_message) { { timestamp: Time.now + 1} }

    it 'should return only new message for this client' do
      full_history = double()
      full_history.stub(:since).with(client.start_time) { [new_message, second_new_message] }
      expect(client.history(full_history)).to eq [new_message.merge({ client_id: client.id }), second_new_message.merge({ client_id: client.id })]
    end

  end

end
