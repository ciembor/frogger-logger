require 'frogger-logger'

module FroggerLogger
  class Configuration
    attr_accessor :host, :port, :history_expiration_time, :extend_with_dsl

    def initialize
      @host = '0.0.0.0'
      @port = 2999
      @history_expiration_time = 600
      @extend_with_dsl = true
    end
  end
end
