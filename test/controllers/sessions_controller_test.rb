require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper

  setup do
    @user = users(:one)  
  end

  test "should get new session page" do
    get new_session_path
    assert_response :success
    assert_select "h1", "Sign in"  # Updated to match the actual text in the view
    puts "✅ should get new session page"
  end

  test "should create a session with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_path
    assert_equal "Signed in successfully.", flash[:notice]
    puts "✅ should create a session with valid credentials"
  end

  test "should not create a session with invalid email" do
    post session_path, params: { email_address: "invalid@example.com", password: "password" }
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
    puts "✅ should not create a session with invalid email"
  end

  test "should not create a session with invalid password" do
    post session_path, params: { email_address: @user.email_address, password: "wrongpassword" }
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
    puts "✅ should not create a session with invalid password"
  end

  test "should destroy session" do
    login_as(@user) # Assuming you have a helper method to sign in a user
    delete session_path
    assert_redirected_to new_session_path
    assert_equal "Signed out successfully.", flash[:notice]
    puts "✅ should destroy session"
  end
end