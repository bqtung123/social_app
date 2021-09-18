require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
     ActionMailer::Base.deliveries.clear
  end
    test 'unsuccessfull signup' do
      get signup_path
      assert_template 'users/new'
      assert_no_difference 'User.count' do
      post users_path, params: {user: {name: '',
                                       email:'example@invalid.org',
                                       password: 'foobar',
                                       password_confirmation: ''}}
       end
      assert_template 'users/new'
    end

    test 'successfull signup' do
      get signup_path
      assert_template 'users/new'
      assert_difference 'User.count', 1 do
      post users_path, params: {user: {name: 'example tutorials',
                                       email:'example@valid.org',
                                       password: 'foobar',
                                       password_confirmation: 'foobar'}}
      
      end
      assert_equal 1,ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      # cannot login
      log_in_as user
      assert_not is_logged_in?
      # get link wrong token, right email
      get edit_account_activation_path("Wrong email", email: user.email)
      assert_not is_logged_in?  
      #get link with right token wrong email
      get edit_account_activation_path(user.activation_token, email: "Wrong")
      assert_not is_logged_in? 
      #get link with right token right email
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template "users/show"
      assert is_logged_in?
      

    end
end
