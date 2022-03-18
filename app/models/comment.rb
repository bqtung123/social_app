class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user
  belongs_to :micropost
  validates :body, presence: true, allow_blank: false

  after_create_commit do
    broadcast_append_to [micropost,:comments], target: "#{dom_id(user,micropost.id)}_comments"
  end

  after_destroy_commit do
    broadcast_remove_to self
  end

  after_update_commit do
    broadcast_replace_to self
  end
end
