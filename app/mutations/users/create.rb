require 'bcrypt'

module Users
  class Create < Mutations::Command
    required do
      string :email, matches: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      string :password, min_length: 8
    end

    def execute
      user = User.create(email: email, password_digest: BCrypt::Password.create(password))
      if user.errors.size > 0
        user.errors.each do |key, message|
          add_error(key, :invalid, message)
          return
        end
      end
      user
    end

  end
end
