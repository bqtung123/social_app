require "rails_helper"

RSpec.describe "Slacks", type: :request do
  let(:user) { create(:user) }
  describe "GET #callback" do
    before { login_as(user, scope: :user) }

    it "returns a success response" do
      stub_request(:post, "https://slack.com/api/oauth.v2.access")
        .with(
          body: {"client_id" => "3436754530455.3486362454816", "client_secret" => "2b24fde9bce6d52bce841856161e0166",
"code" => nil, "redirect_uri" => "https://localhost:3000/auth/callback"}
        ).to_return(status: 200, body: '{"access_token": "1234","incoming_webhook": {"urt": "example.com"}}', headers: {})

      get "/auth/callback"

      expect(response.status).to eq(302)
      expect(response).to redirect_to(root_path)
    end
  end
end
