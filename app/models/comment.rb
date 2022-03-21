class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  acts_as_votable
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: "parent_id", dependent: :destroy

  validates :body, presence: true, allow_blank: false

  after_create_commit do
    if !parent.nil?
      broadcast_append_to [micropost, :comments], target: "#{dom_id(micropost, parent.id)}_comments"
    else
      broadcast_append_to [micropost, :comments], target: "#{dom_id(micropost)}_comments"
    end
  end

  after_destroy_commit do
    broadcast_remove_to self
  end

  after_update_commit do
    broadcast_replace_to self
  end
end
