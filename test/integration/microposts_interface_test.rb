require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    @other_user = users(:archer)
  end
  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"

    # invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: ""}}
    end
    assert_select "div#error_explanation"
    # valid submission
    content = "Thank you everything"
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: content}}
    end
    assert_not flash.empty?
    assert_redirected_to root_url

    # delete post
    assert_difference "Micropost.count", -1 do
      delete micropost_path(@micropost)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    # go into other user profile page
    get user_path(@other_user)
    assert_select "a", text: "delete", count: 0
  end
end
