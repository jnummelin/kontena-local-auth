Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :email, :unique => true, :null=>false, type: String
      field :password_digest, type: String
      field :confirm_token, type: String #, default: ->{ SecureRandom.hex(64) }
      field :password_reset_token, type: String
    end
  end

  down do
    drop_table(:users)
  end
end