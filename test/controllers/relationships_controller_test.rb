require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "create relationship should logged in" do
    post relationships_path, params: {followed_id: @other_user.id}
    assert_redirected_to login_path
  end

  test "destroy relationship should logged in" do
    @user.follow(@other_user)
    @relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    delete relationship_path(@relationship)
    assert_redirected_to login_path
  end
end
