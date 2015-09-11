json.set! :access_token, @access_token.access_token
json.set! :refresh_token, @access_token.refresh_token
#json.set! :token_type, @access_token.token_type
json.set! :expires_in, (@access_token.valid_until - Time.now.utc).to_i
json.user do
  json.id @access_token.user.id.to_s
  json.email @access_token.user.email
end
