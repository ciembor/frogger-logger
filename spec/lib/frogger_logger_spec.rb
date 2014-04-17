require 'spec_helper'

describe FroggerLogger do
  it 'logs messages to websocket' do
    with_running_client { FroggerLogger.log("foo") }.expect_message({method: :log, content: "foo"}.to_json)
  end
end
