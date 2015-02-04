require 'frogger-logger'

module FroggerLogger
  class Configuration
    attr_accessor :host, :port, :history_expiration_time, :extend_with_dsl, :json_format, :client_js_path

    def initialize
      @host = '0.0.0.0'
      @port = 2999
      @client_js_path = '/assets/frogger_logger/client.js'
      @history_expiration_time = 600
      @extend_with_dsl = true
      @json_format = true
    end
  end
end
