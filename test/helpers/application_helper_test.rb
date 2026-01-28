require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # Mock trip_day object for testing
  class MockTripDay
    attr_reader :id
    def initialize(id)
      @id = id
    end
  end

  test "set_day_icon returns icons for 3 days" do
    trip_days = [MockTripDay.new(1), MockTripDay.new(2), MockTripDay.new(3)]
    icons = set_day_icon(trip_days)

    assert_equal 4, icons.keys.count # 3 days + fallback (0)
    assert_match /num1/, icons[1]
    assert_match /num2/, icons[2]
    assert_match /num3/, icons[3]
    assert_match /num6/, icons[0] # fallback
  end

  test "set_day_icon handles 7 days by cycling icons" do
    trip_days = (1..7).map { |i| MockTripDay.new(i) }
    icons = set_day_icon(trip_days)

    assert_equal 8, icons.keys.count # 7 days + fallback
    # Day 7 (index 6) should cycle back to num1.png
    assert_match /num1/, icons[7], "Day 7 should use num1.png (cycled)"
  end

  test "set_day_icon handles 12 days by cycling icons twice" do
    trip_days = (1..12).map { |i| MockTripDay.new(i) }
    icons = set_day_icon(trip_days)

    assert_equal 13, icons.keys.count
    # Day 7 (index 6) -> num1, Day 12 (index 11) -> num6
    assert_match /num1/, icons[7]
    assert_match /num6/, icons[12]
  end

  test "set_day_icon always includes fallback icon at key 0" do
    trip_days = [MockTripDay.new(1)]
    icons = set_day_icon(trip_days)

    assert icons.key?(0), "Should have fallback icon at key 0"
    assert_match /num6/, icons[0]
  end
end
