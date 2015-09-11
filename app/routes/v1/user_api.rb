require_relative '../../mutations/users/create'
require_relative '../../mutations/users/email_password_reset'
require_relative '../../mutations/users/password_reset'

module V1
  class UserApi < Roda
    include OAuth2TokenVerifier
    include CurrentUser
    include RequestHelpers

    route do |r|

      r.on 'email_confirm' do
        r.post do
          data = parse_json_body
          user = User.where(confirm_token: data['token']).first
          if user
            outcome = AccessTokens::Create.run(
                user: user,
                scopes: ['user']
            )
            if outcome.success?
              user.update(:confirm_token => nil)
              @access_token = outcome.result
              render('auth/show')
            else
              response.status = 503
              {error: 'Service unavailable'}
            end
          else
            response.status = 404
            {error: 'Not found'}
          end
        end
      end

      r.on 'password_reset' do
        r.post do
          data = parse_json_body
          user = User.where(email: data['email']).first
          if user
            Users::EmailPasswordReset.run(user: user)
            response.status = 200
            {}
          else
            response.status = 400
            {error: 'Access denied'}
          end
        end

        r.is method: :put do
          data = parse_json_body
          outcome = Users::PasswordReset.run(
              token: data['token'],
              password: data['password']
          )
          if outcome.success?
            response.status = 200
            {}
          else
            response.status = 422
            {error: outcome.errors.message}
          end
        end
      end

      validate_access_token
      require_current_user

      r.get do
        r.is do
          @user = self.current_access_token.user
          render('users/show')
        end
      end
    end
  end
end
