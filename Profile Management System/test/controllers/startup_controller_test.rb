require 'test_helper'

class StartupControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get startup_signup_url
    assert_response :success
  end

end
