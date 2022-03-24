class Micropost < ApplicationRecord
  belongs_to :user
  acts_as_votable
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  has_many :comments, dependent: :destroy

  def self.to_csv
    column_names = %w(content created_at)
    CSV.generate do |csv|
      csv << column_names
      all.each do |micropost|
        csv << column_names.map { |attr| micropost.send(attr)}
      end
    end
  end

  private
  def picture_size
    return unless picture.size > 5.megabytes

    errors.add(:picture, "should be less than 5MB")
  end
end
