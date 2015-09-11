require_relative '../../mutations/users/authenticate'
module V1
  class AuthApi < Roda
    include RequestHelpers
    plugin :json
    plugin :render, engine: 'jbuilder', ext: 'json.jbuilder', views: 'app/views/v1'
    plugin :default_headers, 'Content-Type'=>'application/json'

    route do |r|
      r.post do
        data = parse_json_body
        params = {
            username: data['username'],
            password: data['password'],
            grant_type: data['grant_type'],
            scope: data['scope'].to_s.split(',')
        }
        @access_token = Users::Authenticate.run(params).result
        if @access_token.nil?
          response.status = 400
          { error: 'Invalid username or password' }
        else
          response.status = 201
          render('auth/show')
        end
      end
    end
  end
end
