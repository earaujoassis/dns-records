require "test_helper"

class RecordTest < ActiveSupport::TestCase
  test "should invalidate Record" do
    assert Record.new.invalid?
  end

  test "should validate Record" do
    assert Record.new(ip: "1.1.1.1").valid?
    assert Record.new(ip: "0.0.0.0").valid?
  end
end
