require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:one)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "激活您的账号", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["wangbo@giabbs.com"], mail.from
    # assert_match user.username, mail.body.encoded
    # assert_match user.activation_token, mail.body.encoded
    # assert_match CGI::escape(user.email), mail.body.encoded
  end

=begin
  test "password_reset" do
    mail = UserMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
=end
end
