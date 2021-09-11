require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
     @user = users(:michael)
  end
  test 'unsuccessfull edit' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    patch user_path(@user), params: {user: {name: "",
                                            email: @user.email,
                                            password: "foo",
                                            password_confirmation: "bar"
                                            }}                          
    assert_template 'users/edit'
  end

  test 'successfull edit' do
      get edit_user_path(@user)
      log_in_as(@user)
     assert_redirected_to edit_user_path(@user)
     name = "Michael Lord"
     email = "michael@tutorial.org"
     patch user_path(@user), params: {user: {name: name,
                                            email: email,
                                            password: "",
                                            password_confirmation: ""
                                            }}
      assert_not flash.empty?
      assert_redirected_to @user
      @user.reload
      assert_equal name,@user.name
      assert_equal email,@user.email
  end
end
