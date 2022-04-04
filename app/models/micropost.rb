class Micropost < ApplicationRecord
  CSV_ATTRIBUTES = %w(content created_at).freeze
  belongs_to :user
  acts_as_votable
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  has_many :comments, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user, dependent: :destroy

  private

  def picture_size
    return unless picture.size > 5.megabytes

    errors.add(:picture, 'should be less than 5MB')
  end
end
