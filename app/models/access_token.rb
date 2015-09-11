class AccessToken < Sequel::Model(:access_tokens)

  many_to_one :user

  one_to_many :scopes, key: :access_token_id, class: :Scope
end
