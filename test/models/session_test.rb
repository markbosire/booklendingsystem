require "test_helper"

class SessionTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email_address: "john@example.com", password: "password")
    @session = Session.new(user: @user)
  end

  # Test if the session is valid with a user
  test "session should be valid" do
    assert @session.valid?
    puts "✅ Session is valid with a user"
  end

  # Test presence validation for user association
  test "session should have a user" do
    @session.user = nil
    assert_not @session.valid?, "Session is valid without a user"
    puts "✅ Session requires a user"
  end
end
