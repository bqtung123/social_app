class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: @user.email, subject: 'Account Activation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: @user.email, subject: 'Password Reset'
  end

  def comment_notification
    @micropost = Micropost.find(params[:comment][:micropost_id])
    @user = User.find(params[:comment][:user_id])
    @recipient = @micropost.user
    mail to: @recipient.email, subject: 'Notification'
  end

  def react_notification
    @micropost = Micropost.find(params[:micropost][:id])
    @user = User.find(params[:user][:id])
    @recipient = @micropost.user
    mail to: @recipient.email, subject: 'Notification'
  end
end
