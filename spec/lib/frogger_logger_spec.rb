require 'spec_helper'

describe FroggerLogger do
  [:debug, :warn, :log, :info, :error].each do |method|
    it "sends #{method} messages to websocket" do
      with_running_client { FroggerLogger.send(method, "foo") }.expect_message({method: method, content: "foo"}.to_json)
    end
  end
end
