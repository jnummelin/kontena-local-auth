require 'digest/md5'

class User < Sequel::Model(:users)

  one_to_many   :access_tokens

  def before_create # or after_initialize
    super
    self.confirm_token = SecureRandom.hex(64)
  end

  def validate
    super
    errors.add(:email, "can't be empty") if self.email.nil? || self.email.empty?
    errors.add(:password_digest, "can't be empty") if self.password_digest.nil? || self.password_digest.empty?
  end

  def name
    self.email
  end

  ##
  # @return [Boolean]
  def confirmed?
    self.confirm_token.nil?
  end

  ##
  # @return [Boolean]
  def authenticate(password)
    @password ||= BCrypt::Password.new(self.password_digest)
    @password == password
  end
end