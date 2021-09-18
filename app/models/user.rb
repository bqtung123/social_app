class User < ApplicationRecord
    attr_accessor :remember_token,:activation_token,:reset_token
    before_save :downcase
    before_create :create_activation_digest
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX},
                                                            uniqueness: true
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true
    
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
end
