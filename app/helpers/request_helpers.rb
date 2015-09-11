module RequestHelpers

  def self.included(base)
    base.plugin :json
    base.plugin :all_verbs
    base.plugin :render, engine: 'jbuilder', ext: 'json.jbuilder', views: 'app/views/v1'
    base.plugin :error_handler do |e|
      response.status = 500
      log_message = "\n#{e.class} (#{e.message}):\n"
      log_message << "  " << e.backtrace.join("\n  ") << "\n\n"
      request.logger.error log_message
      json = { message: 'Internal server error' }
      if test_env?
        puts log_message
      end
      json
    end
  end

  def parse_json_body
    JSON.parse(request.body.read)
  rescue => exc
    response.status = 400
    response.write({error: 'Invalid json'}.to_json)
    request.halt
  end

  def halt_request(status, body)
    response.status = status
    response.write(body.to_json)
    request.halt
  end

  def test_env?
    ENV['RACK_ENV'].to_s == 'test'
  end

  def dev_env?
    ENV['RACK_ENV'].to_s == 'development'
  end
end
