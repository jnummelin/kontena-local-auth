Sequel.migration do
  up do
    create_table(:access_tokens) do
      primary_key :id
      String :access_token, :null => false
      String :refresh_token, :null => false
      DateTime :valid_until
      foreign_key :user_id, :users
    end
  end

  down do
    drop_table(:access_tokens)
  end
end