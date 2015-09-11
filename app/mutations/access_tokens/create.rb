require "securerandom"

module AccessTokens
  class Create < Mutations::Command

    required do
      model :user
      array :scopes do
        string in: %w(user)
      end
    end

    def execute
      token = self.user.add_access_token(
          :access_token => "kontena-#{SecureRandom.base64(64)}",
          :refresh_token => SecureRandom.base64(64),
          :valid_until => Time.now + (3 * 60 * 60))

      self.scopes.each do |s|
        token.add_scope(:scope => s)
      end

      token
    end
  end
end
