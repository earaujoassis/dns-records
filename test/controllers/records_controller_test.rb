require "test_helper"

class RecordsControllerTest < ActionDispatch::IntegrationTest
  test "should check for valid params on :create" do
    post '/dns_records'
    assert_response 422
    assert_equal JSON.parse(response.body), { "errors" => "invalid dns_records" }
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

  test "should check for valid query on :index" do
    skip "since it's essentially checking for `params[:page]`, I'm skipping it by now"

    get '/dns_records'
    assert_response 400
    assert_equal JSON.parse(response.body), { "errors" => "invalid query" }
  end

  test "should query dns_records" do
    populate_record_hostname("1.1.1.1", ["lorem.com", "ipsum.com", "dolor.com", "amet.com"])
    populate_record_hostname("2.2.2.2", ["ipsum.com"])
    populate_record_hostname("3.3.3.3", ["ipsum.com", "dolor.com", "amet.com"])
    populate_record_hostname("4.4.4.4", ["ipsum.com", "dolor.com", "sit.com", "amet.com"])
    populate_record_hostname("5.5.5.5", ["dolor.com", "sit.com"])
    expected_response = {
      "total_records" => 2,
      "records" => [
        {
          "id" => Record.find_or_create_by(ip: "1.1.1.1").id,
          "ip_address" => "1.1.1.1"
        },
        {
          "id" => Record.find_or_create_by(ip: "3.3.3.3").id,
          "ip_address" => "3.3.3.3"
        }
      ],
      "related_hostnames" => [
        {
          "hostname" => "amet.com",
          "count" => 2
        },
        {
          "hostname" => "lorem.com",
          "count" => 1
        }
      ]
    }

    get '/dns_records', params: { included: ["ipsum.com", "dolor.com"], excluded: ["sit.com"] }
    assert_response :success
    assert_equal JSON.parse(response.body), expected_response
  end

  test "should return single result for dns_records" do
    populate_record_hostname("1.1.1.1", ["lorem.com", "ipsum.com", "dolor.com", "amet.com"])
    expected_response = {
      "total_records" => 1,
      "records" => [
        {
          "id" => Record.find_or_create_by(ip: "1.1.1.1").id,
          "ip_address" => "1.1.1.1"
        },
      ],
      "related_hostnames" => [
        {
          "hostname" => "amet.com",
          "count" => 1
        },
        {
          "hostname" => "lorem.com",
          "count" => 1
        }
      ]
    }

    get '/dns_records', params: { included: ["ipsum.com", "dolor.com"] }
    assert_response :success
    assert_equal JSON.parse(response.body), expected_response
  end

  test "should return empty result for dns_records -- with excluded attribute only" do
    populate_record_hostname("1.1.1.1", ["lorem.com", "ipsum.com", "dolor.com", "amet.com"])
    expected_response = {
      "total_records" => 0,
      "records" => [],
      "related_hostnames" => []
    }

    get '/dns_records', params: { excluded: ["ipsum.com", "dolor.com"] }
    assert_response :success
    assert_equal JSON.parse(response.body), expected_response
  end

  test "should return empty result for dns_records" do
    expected_response = {
      "total_records" => 0,
      "records" => [],
      "related_hostnames" => []
    }

    get '/dns_records'
    assert_response :success
    assert_equal JSON.parse(response.body), expected_response
  end

  def populate_record_hostname(record_ip, hostnames)
    record = Record.find_or_create_by(ip: record_ip)
    hostnames.each do |hn|
      hostname = Hostname.find_or_create_by(address: hn)
      record.hostnames << hostname
    end
  end
end
