require_relative '../../mutations/users/create'

module V1
  class UsersApi < Roda
    include RequestHelpers

    route do |r|
      r.post do
        r.is do
          params = parse_json_body

          outcome = Users::Create.run(params)
          if outcome.success?
            response.status = 201
            @user = outcome.result
            render('users/show')
          else
            response.status = 422
            {error: outcome.errors.message}
          end
        end
      end
    end
  end
end
