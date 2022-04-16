require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body

    @user.following.each do |following|
      assert_select "a[href=?]", user_path(following)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body

    @user.following.each do |follower|
      assert_select "a[href=?]", user_path(follower)
    end
  end

  test "follow standard way" do
    get user_path(@other_user)
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: {followed_id: @other_user.id}
    end
    assert_redirected_to @other_user
  end

  test "unfollow standard way" do
    @user.follow(@other_user)
    get user_path(@other_user)
    assert_difference "Relationship.count", -1 do
      delete relationship_path(@other_user)
    end
    assert_redirected_to @other_user
  end
end
