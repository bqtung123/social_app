class SlackController < ApplicationController
  before_action :authenticate_user!
  def callback
    client = Slack::Web::Client.new
    response = client.oauth_v2_access(
      client_id: "3436754530455.3486362454816",
      client_secret: "2b24fde9bce6d52bce841856161e0166",
      code: params[:code],
      redirect_uri: "https://localhost:3000/auth/callback"
    ).to_json

    value = JSON.parse(response)
    puts value
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
    notifier.post text: "Hello lalala", username: "Boss", icon_url: "http://static.mailchimp.com/web/favicon.png"
    flash[:success] = "Posted to Slack!"
    redirect_to root_path
  end
end
