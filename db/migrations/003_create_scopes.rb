Sequel.migration do
  up do
    create_table(:scopes) do
      primary_key :id
      String :scope, :null => false
      foreign_key :access_token_id, :access_tokens
    end
  end

  down do
    drop_table(:scopes)
  end
end