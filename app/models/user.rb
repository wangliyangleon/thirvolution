class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable,
         :omniauth_providers => [:google_oauth2]

  has_many :daily_finish_records
  has_many :activities, through: :daily_finish_records
  has_many :participation_records
  has_many :activities, through: :participation_records
  has_many :activity_comments
  has_many :activities, through: :activity_comments

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      username = data["name"].tr('^a-zA-Z0-9_\.', '')
      if username.length == 0
        # TODO: handle the bad luck case :(
        username = "user%d" % rand(99999999)
      end
      user = User.create(
        provider: access_token.provider,
        uid: access_token.uid,
        username: username,
        email: data["email"],
        password: Devise.friendly_token[0,20],
        nickname: data["name"]
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
    },
    :length => {
      :maximum => 16
    }

  validates :nickname,
    :length => {
      :maximum => 16
    }

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  before_save :default_values
  def default_values
    self.nickname ||= self.username
  end

end
