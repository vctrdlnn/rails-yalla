require 'test_helper'

class TripMailerTest < ActionMailer::TestCase
  def setup
    @trip_owner = OpenStruct.new(username: 'tripowner')
    @trip = OpenStruct.new(
      title: 'Paris Adventure',
      description: 'A lovely trip to Paris',
      user: @trip_owner,
      trip_days: []
    )
    @user = OpenStruct.new(
      email: 'user@example.com',
      name: 'Trip User'
    )
  end

  test "send_trip has correct recipient and subject" do
    email = TripMailer.send_trip(@trip, @user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['user@example.com'], email.to
    assert_equal ['contact@justyalla.app'], email.from
    assert_equal 'Hi Trip User, details of Paris Adventure', email.subject
  end
end
