require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  def setup
    @user = users(:michael)
  end
  test "profile user test" do
    get user_path(@user)
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    assert_select "h1>img.gravatar"
    assert_match @user.microposts.count.to_s, response.body
    assert_select "div.pagination"
    @user.microposts.paginate(page: 1) do |m|
      assert_equal m.content, response.body
    end
  end
end
