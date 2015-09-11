require_relative '../../spec_helper'
require 'active_support'

describe '/v1/user' do

  let(:request_headers) do
    {
      'HTTP_AUTHORIZATION' => "Bearer #{valid_token.access_token}"
    }
  end

  let(:david) do
    user = User.create(email: 'david@domain.com', password_digest: BCrypt::Password.create("password"))

    user
  end

  let(:valid_token) do
    token = AccessToken.create(:user => david,
                               :access_token => "kontena-#{SecureRandom.base64(64)}",
                               :refresh_token => SecureRandom.base64(64),
                               :valid_until => Time.now + (3 * 60 * 60))
    token.add_scope(:scope => 'user')
    token
  end

  describe 'POST /email_confirm' do
    it 'returns access token with valid confirm token' do
      data = { token: david.confirm_token }
      expect {
        post '/v1/user/email_confirm', data.to_json
        expect(response.status).to eq(200)
        expect(json_response['access_token']).not_to be_nil
      }.to change{ david.reload.access_tokens.count }.by(1)
    end
  end

  describe 'POST /password_reset' do
    it 'sets password reset token to user' do
      data = { email: david.email }
      expect {
        post '/v1/user/password_reset', data.to_json
        expect(response.status).to eq(200)
      }.to change{ david.reload.password_reset_token }.from(nil)
    end
  end

  describe 'PUT /password_reset' do
    context 'with valid token' do
      it 'sets user password' do
        david.update(:password_reset_token => SecureRandom.hex(24))
        data = { token: david.password_reset_token, password: 'newpassword987'}
        expect {
          put '/v1/user/password_reset', data.to_json
          expect(response.status).to eq(200)
        }.to change{ david.reload.password_digest }
      end

      it 'resets password_reset_token to nil' do
        david.update(:password_reset_token => SecureRandom.hex(24))
        data = { token: david.password_reset_token, password: 'newpassword987'}
        expect {
          put '/v1/user/password_reset', data.to_json
          expect(response.status).to eq(200)
        }.to change{ david.reload.password_reset_token }.to(nil)
      end
    end

    context 'with invalid token' do
      it 'returns error' do
        data = { token: 'invalid_token', password: 'newpassword987'}
        put '/v1/user/password_reset', data.to_json
        expect(response.status).to eq(422)
        expect(json_response['error']['token']).to eq('Invalid token')
      end
    end
  end

  describe 'GET' do
    it 'returns current user' do
      get '/v1/user', nil, request_headers
      expect(last_response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(david.id.to_s)
      expect(json['email']).to eq(david.email)
    end

    it 'returns error without authorization' do
      get '/v1/user'
      expect(response.status).to eq(403)
    end
  end
end
