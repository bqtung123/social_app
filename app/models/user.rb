class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable
  
  acts_as_voter
  has_many :providers, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships

  
  # attr_accessor :remember_token, :activation_token, :reset_token

  # before_save :downcase
  # before_create :create_activation_digest
  after_create :assign_default_role

  validates :name, presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  # has_secure_password
  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
  # edit in there
  def self.from_omniauth auth
    user = User.where(email: auth.info.email).first
    expires_at = auth.credentials.expires_at
    token = auth.credentials.token
    if user
      if (provider = user.providers.find_by(provider: auth.provider))
        provider.update(oauth_token: auth.credentials.token, oauth_expires_at: Time.at(expires_at))
      else
        user.providers.create(provider: auth.provider, oauth_token: token, oauth_expires_at: Time.at(expires_at))
      end
    else
      user = where(email: auth.info.email).first_or_create do |u|
        u.email = auth.info.email
        u.name = auth.info.name
        u.password = u.password_confirmation = User.new_token
        u.activated = 1
      end

      user.providers.create(provider: auth.provider, oauth_token: token, oauth_expires_at: Time.at(expires_at))
    end
    user
  end

  def downcase
    self.email = email.downcase
  end

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def reset_expired?
    reset_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id  = :user_id", user_id: id)
  end

  def follow other_user
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include?(other_user)
  end
end
