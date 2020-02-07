require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get admins_search_url
    assert_response :success
  end

  test "should get report" do
    get admins_report_url
    assert_response :success
  end

end
