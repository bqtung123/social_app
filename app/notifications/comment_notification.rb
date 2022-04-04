# To deliver this notification:
#
# CommentNotification.with(micropost: @micropost).deliver_later(current_user)
# CommentNotification.with(micropost: @micropost).deliver(current_user)

class CommentNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :action_cable,
             channel: NotificationsChannel,
             stream: :custom_stream,
             format: :action_cable_data

  deliver_by :email, mailer: 'UserMailer'

  def custom_stream
    @micropost = Micropost.find(params[:comment][:micropost_id])
    @micropost.user
  end

  def action_cable_data
    {
      message:
        "<li class='dropdown-item'>
          <a href='#{self.url}'><b>#{self.message}</b></a>
        </li>"
    }
  end

  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :micropost

  # Define helper methods to make rendering easier.
  #
  def message
    @micropost = Micropost.find(params[:comment][:micropost_id])
    @comment = Comment.find(params[:comment][:id])
    @user = User.find(@comment.user_id)
    "#{@user.name} commented on your micropost"
  end

  def url
    micropost_path(Micropost.find(params[:comment][:micropost_id]))
  end
end
