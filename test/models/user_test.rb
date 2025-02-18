# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email_address: "john@example.com", 
                     password: "password", 
                     password_confirmation: "password")
  end

  # Test if the user is valid with all attributes
  test "user should be valid" do
    assert @user.valid?
    puts "✅ User is valid with all required attributes"
  end

  # Test presence validation for email address
  test "user should have an email address" do
    @user.email_address = ""
    assert_not @user.valid?, "User is valid without an email address"
    puts "✅ User requires an email address"
  end

  # Test presence validation for password
  test "user should have a password" do
    @user = User.new(email_address: "john@example.com", password: nil, password_confirmation: nil)
    assert_not @user.valid?, "User is valid without a password"
    puts "✅ User requires a password"
  end

  # Test password minimum length
  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "12345"
    assert_not @user.valid?, "User is valid with a short password"
    puts "✅ Password requires minimum length"
  end

  # Test that email is normalized (leading/trailing spaces should be stripped, lowercase applied)
  test "email address should be normalized" do
    @user.email_address = "  JOHN@example.com  "
    @user.save
    assert_equal "john@example.com", @user.reload.email_address
    puts "✅ Email address is normalized"
  end

  # Test email uniqueness
  test "email address should be unique" do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email_address = @user.email_address
    assert_not duplicate_user.valid?, "User is valid with a duplicate email address"
    puts "✅ Email address must be unique"
  end

  # Test has_secure_password functionality
  test "should authenticate with correct password" do
    @user.save
    assert @user.authenticate("password")
    puts "✅ User authenticates with correct password"
  end

  test "should not authenticate with incorrect password" do
    @user.save
    assert_not @user.authenticate("wrongpassword")
    puts "✅ User does not authenticate with incorrect password"
  end

  # Test associations (sessions and borrowings)
  test "should have many sessions" do
    assert_respond_to @user, :sessions
    puts "✅ User has many sessions"
  end

  test "should have many borrowings" do
    assert_respond_to @user, :borrowings
    puts "✅ User has many borrowings"
  end

  test "should have many books through borrowings" do
    assert_respond_to @user, :books
    puts "✅ User has many books through borrowings"
  end

  # Test for dependent destroy
  test "should destroy dependent sessions when user is destroyed" do
    @user.save
    @user.sessions.create!
    assert_difference 'Session.count', -1 do
      @user.destroy
    end
    puts "✅ User destroys dependent sessions"
  end
end