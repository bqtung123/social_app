require "rails_helper"
RSpec.describe Notification, type: :model do
  describe "when first created" do
    it "should be empty" do
      expect(subject.type).to be_nil
    end
  end
end
