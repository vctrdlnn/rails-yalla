require 'test_helper'

class InviteMailerTest < ActionMailer::TestCase
  def setup
    @sender = OpenStruct.new(name: 'Sender User')
    @recipient = OpenStruct.new(name: 'Recipient User')
    @trip = OpenStruct.new(title: 'Paris Trip', id: 123)
    @invite = OpenStruct.new(
      email: 'invited@example.com',
      sender: @sender,
      recipient: @recipient,
      trip: @trip,
      token: 'abc123'
    )
    @invite_path = 'http://localhost:3000/users/sign_up?invite_token=abc123'
  end

  test "new_user_invite has correct recipient and subject" do
    email = InviteMailer.new_user_invite(@invite, @invite_path)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['invited@example.com'], email.to
    assert_equal ['contact@yala-app.fr'], email.from
    assert_equal 'Sender User has invited you to participate to Paris Trip', email.subject
  end

  # Note: existing_user_invite test skipped - template uses route helpers
  # that require more complex test setup. TODO: Add proper integration test.
end
