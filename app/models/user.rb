class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable,
         :omniauth_providers => [:google_oauth2]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(
        provider: access_token.provider,
        uid: access_token.uid,
        username: data["name"],
        email: data["email"],
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  validate :validate_username
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end


end
