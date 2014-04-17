require 'bundler/setup'
require 'frogger-logger'
require 'support/dummy_client'
require 'support/client_expectations'

Bundler.setup

RSpec.configure do |config|
  config.include ClientExpectations
  config.after(:each) do
    if EM::reactor_running?
      EM::stop_event_loop
    end
  end
end
