require "test_helper"

class CurrentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email_address: "john@example.com", password: "password")
    @session = Session.create!(user: @user)
  end

  # Test setting and retrieving the session
  test "can set and retrieve session" do
    Current.session = @session
    assert_equal @session, Current.session
    puts "✅ Current.session stores the session correctly"
  end

  # Test retrieving user via delegate
  test "can retrieve user from session" do
    Current.session = @session
    assert_equal @user, Current.user
    puts "✅ Current.user correctly delegates to session.user"
  end

  # Test behavior when session is nil
  test "returns nil user when session is nil" do
    Current.session = nil
    assert_nil Current.user
    puts "✅ Current.user is nil when session is nil"
  end
end
