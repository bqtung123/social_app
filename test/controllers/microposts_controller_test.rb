require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test "before create should login" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: "ABCDEFGHJK"}}
    end
    assert_redirected_to login_path
  end

  test "before destroy should login" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_path
  end

  test "correct user when delete micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
