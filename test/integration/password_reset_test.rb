require "test_helper"

class PasswordResetTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user=users(:michael)
 end
   test "test password reset" do
     get new_password_reset_path
     assert_template 'password_resets/new'

     #invalid email
     post password_resets_path, params: {password_reset: {email: ""} }
     assert_not flash.empty?

     #valid email
     post password_resets_path, params: {password_reset: {email: @user.email} }
     assert_equal 1,ActionMailer::Base.deliveries.size
     assert_not_equal @user.reset_digest, @user.reload.reset_digest
     assert_not flash.empty?
     assert_redirected_to root_url

     user=assigns(:user)
     assert_not is_logged_in?
     #wrong email
     get edit_password_reset_path(user.reset_token,email: "")
     assert_not flash.empty?
     assert_redirected_to root_url

     #inactive user
     user.toggle!(:activated)
     get edit_password_reset_path(user.reset_token,email: @user.email)
     assert_redirected_to root_url
     user.toggle!(:activated)

     #right user,wrong token
     get edit_password_reset_path("wrong token",email: @user.email)
     assert_not flash.empty?
     assert_redirected_to root_url

     #right user,right token
     get edit_password_reset_path(user.reset_token,email: @user.email)
     assert_template "password_resets/edit"

     #invalid password
     patch password_reset_path(user.reset_token), params: {email: user.email,user: { password: "fooooooo",
                                                password_confirmation:"bazzzzzzz"
                                                    }
                                                  }
      
       assert_select 'div#error_explanation'
      #empty password
       patch password_reset_path(user.reset_token), params: {email: user.email,user: { password: "",
                                                password_confirmation:"bazzzzzzz"}
                                              }
       assert_select 'div#error_explanation'
      #valid password
      patch password_reset_path(user.reset_token), params: {email: user.email,user: { password: "foobaz1",
                                               password_confirmation:"foobaz1"}
                                              }
      assert_not flash.empty?
      assert is_logged_in?
      assert_redirected_to user
   end
end
