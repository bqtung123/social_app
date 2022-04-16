require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example Tutorial", email: "example@tutorial.org", password: "password",
password_confirmation: "password")
  end

  test "should valid" do
    assert @user.valid?
  end

  test "name should be not blank" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be not blank" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "name should be maximum 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be maximum 50 characters" do
    @user.email = "#{'a' * 244}@example.org"
    assert_not @user.valid?
  end

  test "email invalid" do
    invalid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                                          foo@bar_baz.com foo@bar+baz.com)
    invalid_addresses.each do |invalid|
      @user.email = invalid
      assert_not @user.valid?, "#{@user.email.inspect} is invalid email"
    end
  end
  test "email should unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should downcase before save database" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should minimum 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? return false when remember digest nil" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "micropost destroyed when user destroy" do
    @user.save
    @user.microposts.create!(content: "Example content")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "relationship" do
    @user = users(:michael)
    @other_user = users(:archer)
    @user.follow(@other_user)
    assert @user.following?(@other_user)
    assert @other_user.followers.include?(@user)
    @user.unfollow(@other_user)
    assert_not @user.following?(@other_user)
  end

  test "feed" do
    @user = users(:michael)
    @followed_user = users(:lana)
    @unfollow_user = users(:archer)

    @user.microposts.each do |post|
      assert @user.feed.include?(post)
    end

    @followed_user.microposts.each do |followed_post|
      assert @user.feed.include?(followed_post)
    end

    @unfollow_user.microposts.each do |unfollow_post|
      assert_not @user.feed.include?(unfollow_post)
    end
  end
end
