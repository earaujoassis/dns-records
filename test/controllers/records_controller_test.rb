require "test_helper"

class RecordsControllerTest < ActionDispatch::IntegrationTest
  test "should check for valid params on :create" do
    post '/dns_records'
    assert_response 422
  end

  test "should create" do
    record_id = Record.create(ip: "1.1.1.1").id
    post '/dns_records',
      params: { dns_records: { ip: "1.1.1.1", hostnames_attributes: [{ hostname: "lorem.com" }] } }, as: :json
    assert_response :success
    assert_equal JSON.parse(response.body), { "id" => record_id }
    assert Record.find_by(ip: "1.1.1.1").hostnames.length == 1
    assert Record.find_by(ip: "1.1.1.1").hostnames.first.address == "lorem.com"
  end
end
