require_relative '../../spec_helper'
require 'bcrypt'


describe '/v1/auth' do
  let(:david) do
    User.create(email: 'david@domain.com', password_digest: BCrypt::Password.create("password"))
  end

  describe 'POST' do
    it 'creates access token' do
      data = {
        username: david.email,
        password: 'password',
        grant_type: 'password',
        scope: 'user'
      }
      expect {
        post '/v1/auth', data.to_json
        expect(response.status).to eq(201)
      }.to change{ AccessToken.count }.by(1)
    end
  end
end
