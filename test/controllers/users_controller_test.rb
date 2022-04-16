require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  test "should redirect login before edit" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect login before update" do
    patch user_path(@user), params: {user: { name: "Michael Lord",
                                             email: "lord@example.org",
                                             password: "",
                                             password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should right user when edit" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should right user when update" do
    log_in_as(@other_user)
    patch user_path(@user), params: {user: { name: "Michael Lord",
                                             email: "lord@example.org",
                                             password: "",
                                             password_confirmation: "" }}
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "get index not loggin should redirect to loggin" do
    get users_path
    assert_redirected_to login_path
  end

  test "delete without login" do
    delete user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "log in with non admin" do
    log_in_as(@other_user)
    delete user_path(@user)
    assert_redirected_to root_path
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end
