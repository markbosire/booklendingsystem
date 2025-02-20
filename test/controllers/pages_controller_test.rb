require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper

  setup do
    @user = users(:one)
  end

  test "should redirect to dashboard if authenticated" do
    login_as(@user)
    get root_path
    assert_redirected_to dashboard_path
    puts "✅ should redirect to dashboard if authenticated"
  end

  test "should render home if not authenticated" do
    get root_path
    assert_response :success
    assert_select "h1", "Welcome to the Book Lending System"
    puts "✅ should render home if not authenticated"
  end

  test "should redirect to login if not authenticated when accessing dashboard" do
    get dashboard_path
    assert_redirected_to new_session_path
    puts "✅ should redirect to login if not authenticated when accessing dashboard"
  end

  test "should render dashboard if authenticated" do
    login_as(@user)
    get dashboard_path
    assert_response :success
    assert_select "h1", "Dashboard"
    assert_select "div", /Recent Books/
    puts "✅ should render dashboard if authenticated"
  end
end
