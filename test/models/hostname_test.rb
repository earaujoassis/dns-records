require "test_helper"

class HostnameTest < ActiveSupport::TestCase
  test "should invalidate Hostname" do
    assert Hostname.new.invalid?
  end

  test "should validate Hostname" do
    assert Hostname.new(address: "test.com").valid?
    assert Hostname.new(address: "4s.co").valid?
  end
end
