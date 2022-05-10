module SlackHelper
  def get_response code = ""
    # client = Slack::Web::Client.new
    # response = client.oauth_v2_access(
    #   client_id: "3436754530455.3486362454816",
    #   client_secret: "2b24fde9bce6d52bce841856161e0166",
    #   code: code,
    #   redirect_uri: "https://localhost:3000/auth/callback"
    # ).to_json

    uri = URI("https://slack.com/api/oauth.v2.access")
    response = Net::HTTP.post_form(uri, client_id: "3436754530455.3486362454816",
                                        client_secret: "2b24fde9bce6d52bce841856161e0166",
                                        code: code,
                                        redirect_uri: "https://localhost:3000/auth/callback").body
    JSON.parse(response)
  end
end
