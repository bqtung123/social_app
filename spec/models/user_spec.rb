require "rails_helper"

FactoryBot.define do
  factory :user do
    name {"Bui Tung"}
    email {"bqtung12@gmail.com"}
    password {"tung0601"}
  end
end

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context "when create the first user" do
    it { expect(user.name).to eq("Bui Tung") }

    it { expect(user.email).to eq("bqtung12@gmail.com") }
  end
end
