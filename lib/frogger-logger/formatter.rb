require 'json'

module FroggerLogger
  class Formatter
    def initialize(json_format)
      @json_format = json_format
    end

    def format(content)
      to_json?(content) ? content.to_json : content
    end

    def to_json?(content)
      if @json_format
        if content.respond_to?(:to_json)
          true unless content.class == String
        end
      end
    end
  end
end