class SlackController < ApplicationController
  include SlackHelper
  before_action :authenticate_user!
  def callback
    value = get_response(params[:code])
    if current_user.update(
      slack_access_token: value["access_token"],
      slack_incoming_webhook_url: value["incoming_webhook"]["url"]
    )
      redirect_to root_path
    else
      render text: "Oops! There was a problem."
    end
  end

  def post_message
    notifier = Slack::Notifier.new current_user.slack_incoming_webhook_url
    notifier.post text: params[:message][:content], username: "Boss", icon_url: "http://static.mailchimp.com/web/favicon.png"
    flash[:success] = "Posted to Slack!"
    redirect_to current_user
  end
end
