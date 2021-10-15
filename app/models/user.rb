class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", 
                                    dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed

    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :followers, through: :passive_relationships 
    attr_accessor :remember_token,:activation_token,:reset_token
    before_save :downcase
    before_create :create_activation_digest
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX},
                                                            uniqueness: true
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true


    def self.from_omniauth(auth)
        result = User.where(email: auth.info.email).first
        if result
          return result
        else
          where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
            
            user.email = auth.info.email 
            user.name = auth.info.name
            user.provider = auth.provider
            user.uid = auth.uid
            user.oauth_token = auth.credentials.token
            user.password=user.password_confirmation=User.new_token
            user.activated = 1
            user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          end
        end
      end
    
    def downcase
        self.email = email.downcase
    end

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
       SecureRandom.urlsafe_base64
    end

    def create_activation_digest
     self.activation_token = User.new_token
     self.activation_digest = User.digest(activation_token)
    end

    def create_reset_digest
        self.reset_token= User.new_token
        update_attribute(:reset_digest,User.digest(reset_token))
        update_attribute(:reset_at,Time.zone.now)
    end

    def send_password_reset_email
          UserMailer.password_reset(self).deliver_now
    end

    def remember
         self.remember_token = User.new_token
         update_attribute(:remember_digest,User.digest(remember_token))
    end

    def forget
       update_attribute(:remember_digest, nil)
    end

    def authenticated?(attribute,token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def reset_expired?
          reset_at < 2.hours.ago
    end

    def feed
        following_ids= "SELECT followed_id FROM relationships WHERE follower_id = :user_id "
         Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",user_id: id)
    end

    def follow(other_user)
         active_relationships.create(followed_id: other_user.id)
    end

    def unfollow(other_user)
       active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
         following.include?(other_user)
    end
end
