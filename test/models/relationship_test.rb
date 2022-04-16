require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @relationship = Relationship.new(follower_id: @user.id, followed_id: @other_user.id)
  end

  test "should valid relationship" do
    assert @relationship.valid?
  end

  test "follower id should presence" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "followed id should presence" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
