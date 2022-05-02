require "rails_helper"

RSpec.describe "Slacks", type: :request do
  describe "GET /callback" do
    it "returns http success" do
      get "/slack/callback"
      expect(response).to have_http_status(:success)
    end
  end
end
