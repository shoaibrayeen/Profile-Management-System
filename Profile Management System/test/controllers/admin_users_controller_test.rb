require 'test_helper'

class AdminUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get admin_users_signup_url
    assert_response :success
  end

end
