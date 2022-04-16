# To deliver this notification:
#
# ReactNotification.with(post: @post).deliver_later(current_user)
# ReactNotification.with(post: @post).deliver(current_user)

class ReactNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :action_cable,
             channel: NotificationsChannel,
             stream: :custom_stream,
             format: :action_cable_data

  deliver_by :email, mailer: "UserMailer"

  def custom_stream
    @micropost = Micropost.find(params[:micropost][:id])
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

  # deliver_by :email, mailer: 'UserMailer'

  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @micropost = Micropost.find(params[:micropost][:id])
    @user = User.find(params[:user][:id])
    "#{@user.name} liked on your micropost"
  end

  def url
    micropost_path(Micropost.find(params[:micropost][:id]))
  end
end
