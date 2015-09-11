require_relative '../../spec_helper'

describe '/v1/users' do

  describe 'POST' do
    it 'creates a new user' do
      data = {
        email: 'john@domain.com',
        password: 'secret1234'
      }
      expect {
        post '/v1/users', data.to_json
        expect(response.status).to eq(201)
        expect(json_response['email']).not_to be_nil
      }.to change{ User.count }.by(1)
    end

    it 'returns error without valid email' do
      data = {
          email: 'john@domain',
          password: 'secret1234'
      }
      expect {
        post '/v1/users', data.to_json
        expect(response.status).to eq(422)
        expect(json_response['error']['email']).not_to be_nil
      }.to change{ User.count }.by(0)
    end

    it 'returns error without password' do
      data = {
          email: 'john@domain.com'
      }
      expect {
        post '/v1/users', data.to_json
        expect(response.status).to eq(422)
        expect(json_response['error']['password']).not_to be_nil
      }.to change{ User.count }.by(0)
    end
  end
end
