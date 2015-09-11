module Users
  class EmailPasswordReset < Mutations::Command
    required do
      model :user
    end

    def execute
      self.user.update(:password_reset_token => SecureRandom.base64(64))

      self.user
    end
  end
end