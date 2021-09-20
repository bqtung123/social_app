require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user=users(:michael)
    @micropost = @user.microposts.build(content: "This is content of michael")
  end
  
  test "valid micropost" do
    assert @micropost.valid?
  end

  test "user_id should presence" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should presence" do
       @micropost.content= nil
       assert_not @micropost.valid?
  end
  
  test "content should max 140 characters" do
        @micropost.content = "a" * 141
        assert_not @micropost.valid?
  end

  test "order" do
     assert_equal microposts(:most_recent),Micropost.first
  end
end
