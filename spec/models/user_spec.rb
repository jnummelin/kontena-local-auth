require_relative '../spec_helper'

describe User do

  it 'saves new user to db' do
    expect {
      user = User.create(:email => 'john@doe.com', :password_digest => 'foo')
    }.to change{User.all.size} .by(1)
  end

  it 'will not save user entry without email' do
    expect {
      User.create(:email => '')
    }.to raise_error(Sequel::ValidationFailed)
  end

  it 'will not save user entry without password digest' do
    expect {
      User.create(:email => 'foo@bar.com')
    }.to raise_error(Sequel::ValidationFailed)
  end

  it 'saves new user to db and creates configrmation token' do
    user = User.create(:email => 'john@doe.com', :password_digest => 'foo')
    expect(User.first(:email => 'john@doe.com')).to eq(user)
    expect(user.confirm_token).not_to be_nil
  end

  it 'fails to create new user with duplicate email' do
    user = User.create(:email => 'john@doe.com', :password_digest => 'foo')
    expect {
      user = User.create(:email => 'john@doe.com', :password_digest => 'foo')
    }.to raise_error
  end

end