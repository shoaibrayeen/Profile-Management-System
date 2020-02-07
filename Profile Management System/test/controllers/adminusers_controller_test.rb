require 'test_helper'

class AdminusersControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get adminusers_signup_url
    assert_response :success
  end

end
