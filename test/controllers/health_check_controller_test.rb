require "test_helper"

class HealthCheckControllerTest < ActionDispatch::IntegrationTest
  test "should return success" do
    get '/health_check'
    assert_response :success
  end
end
