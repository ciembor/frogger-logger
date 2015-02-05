require 'frogger-logger'
require 'nokogiri'

module FroggerLogger
  class Middleware
    def initialize(app)
      @app = app
      FroggerLogger.init
    end

    def call(env)
      start_time = Time.now
      status, headers, response = @app.call(env)
      if is_html(headers)
        client_id = FroggerLogger.init_request(start_time)
        body = response.body
        response.body = body_with_client_config(body, client_id)
      end
      [status, headers, response]
    end

    def is_html(headers)
      headers && headers['Content-Type'] && headers['Content-Type'].include?('text/html')
    end

    def client_config(client_id)
      config = {
        PORT: FroggerLogger.configuration.port,
        ID: client_id
      }
    end

    def client_config_script(client_id)
      "<script>FroggerLogger = #{ client_config(client_id).to_json }</script>"
    end

    def client_script
      "<script src=\"#{ FroggerLogger.configuration.client_js_path }\"></script>"
    end

    def body_with_client_config(body, client_id)
      client_config = ::Nokogiri::XML(client_config_script(client_id)).css('script').first
      client = ::Nokogiri::XML(client_script).css('script').first
      body = ::Nokogiri::HTML(body)
      body.css('script').before(client)
      body.css('script').before(client_config)
      body.to_s
    end

  end
end