class MessagesController < ApplicationController
  load_and_authorize_resource :room
  load_and_authorize_resource :message

  def create
    @message = current_user.messages.new(message_params)
    @message.room = @room
    @message.save
  end

  def message_params
    params.require(:message).permit(:content, :picture)
  end
end
