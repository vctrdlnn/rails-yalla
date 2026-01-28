require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = OpenStruct.new(
      email: 'test@example.com',
      name: 'Test User',
      username: 'testuser'
    )
  end

  test "welcome email has correct recipient and subject" do
    email = UserMailer.welcome(@user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['test@example.com'], email.to
    assert_equal ['contact@justyalla.eu'], email.from
    assert_equal 'Hi Test User, welcome to Justyalla!', email.subject
  end
end
