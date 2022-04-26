require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "post index" do
    sign_in users(:regular)
    visit root_path
    assert_selector "h3", text: "Micropost Feed"
    fill_in "micropost_content",	with: "new text"
    click_on "Post"

    assert_selector "a", text: users(:regular).name
    assert_selector "span", text: "new text"
  end

  test "Edit user" do
    sign_in users(:regular)
    visit edit_user_registration_path
    assert_selector "h1", text: "Edit User"
    fill_in "Password",	with: "tung0601"
    fill_in "Password confirmation",	with: "tung0601"
    fill_in "Current password",	with: "foobar"
    click_on "Update"

    assert_selector "div", text: "Your account has been updated successfully."
  end

  test "Edit user error" do
    sign_in users(:regular)
    visit edit_user_registration_path
    assert_selector "h1", text: "Edit User"

    click_on "Update"

    assert_selector "h2", text: "1 error prohibited this user from being saved:"
    assert_selector "li", text: "Current password can't be blank"
  end
end
