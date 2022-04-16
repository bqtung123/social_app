class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { broadcast_append_to self.room }
  before_create :confirm_participant
  mount_uploader :picture, PictureUploader

  def confirm_participant
    return unless self.room.is_private

    is_participant = Participant.where(user_id: self.user.id, room_id: self.room.id).first
    throw :abort unless is_participant
  end
end
