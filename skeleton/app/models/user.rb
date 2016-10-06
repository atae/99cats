class User < ActiveRecord::Base
  attr_reader :password
  validates :password_digest, presence: true
  validates :user_name, :session_token, presence:true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token
  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat
  has_many :cat_rental_requests

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil? || password.nil?

    if user.is_password?(password)
      return user
    else
      nil
    end
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end



  def is_password?(password)
    bc_obj = BCrypt::Password.new(self.password_digest)
    bc_obj.is_password?(password)
  end


end
