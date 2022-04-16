class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  acts_as_votable
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: "parent_id", dependent: :destroy

  validates :body, presence: true, allow_blank: false
  has_noticed_notifications model_name: "Notification"

  after_create_commit :broadcast_and_notify_recipient

  after_destroy_commit { broadcast_remove_to self }

  after_update_commit { broadcast_replace_to self }

  before_destroy :cleanup_notifications

  def cleanup_notifications
    notifications_as_comment.destroy_all
  end

  def broadcast_and_notify_recipient
    if parent.present?
      broadcast_append_to [micropost, :comments], target: "#{dom_id(micropost, parent.id)}_comments"
    else
      broadcast_append_to [micropost, :comments], target: "#{dom_id(micropost)}_comments"
    end
    CommentNotification.with(comment: self, micropost: micropost).deliver_later(micropost.user)
  end
end
