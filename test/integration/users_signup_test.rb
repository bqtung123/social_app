require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup

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
      follow_redirect!
      end
      assert_template 'users/show'
      assert is_logged_in?
    end
end
