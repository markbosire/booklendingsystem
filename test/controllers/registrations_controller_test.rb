require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_params = {
      email_address: "newuser@example.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  test "should get new registration page" do
    get new_registration_path
    assert_response :success
    assert_select "h1", "Sign Up"
    puts "✅ should get new registration page"
  end

  test "should create a new user with valid parameters" do
    assert_difference("User.count", 1) do
      post registration_path, params: { user: @user_params }
    end
    assert_redirected_to root_path
    assert_equal "Successfully signed up!", flash[:notice]
    puts "✅ should create a new user with valid parameters"
  end

  test "should not create a new user with invalid email" do
    invalid_params = @user_params.merge(email_address: "invalid-email")
    assert_no_difference("User.count") do
      post registration_path, params: { user: invalid_params }
    end
    assert_response :unprocessable_entity
    assert_select "div", /Email address is invalid/
    puts "✅ should not create a new user with invalid email"
  end

  test "should not create a new user with mismatched passwords" do
    invalid_params = @user_params.merge(password_confirmation: "mismatch")
    assert_no_difference("User.count") do
      post registration_path, params: { user: invalid_params }
    end
    assert_response :unprocessable_entity
    assert_select "div", /Password confirmation doesn't match Password/
    puts "✅ should not create a new user with mismatched passwords"
  end

  test "should not create a new user with missing password" do
    invalid_params = @user_params.merge(password: "")
    assert_no_difference("User.count") do
      post registration_path, params: { user: invalid_params }
    end
    assert_response :unprocessable_entity
    assert_select "div", /Password can't be blank/
    puts "✅ should not create a new user with missing password"
  end
end
