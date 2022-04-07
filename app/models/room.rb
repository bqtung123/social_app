class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each { |user| Participant.create(user_id: user.id, room_id: single_room.id) }
    single_room
  end
end
