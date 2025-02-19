require "test_helper"

class PagesDashboardTest < ActionDispatch::IntegrationTest
  include SignInHelper

  setup do
    @user = users(:one) # Load a user fixture
    login_as(@user) # Log in the user
  end

  test "user can view dashboard with navbar and recent books" do
    get dashboard_path
    assert_response :success

    # Check navbar elements
    assert_select ".logo-section i.bx-book-open"
    assert_select ".logo-section i.bx-library"
    assert_select ".logo-section i.bx-bookmark"

    # Check nav links
    assert_select ".nav-links a.nav-link", count: 2 do
      assert_select "i.bx-book"
      assert_select "span", text: "View All Books"
      assert_select "i.bx-user"
  
    end

  

    puts "✅ Navbar rendered correctly"
  end

  test "renders main content correctly" do
    get dashboard_path
    assert_response :success

    # Dashboard heading
    assert_select "h1", text: "Dashboard"
    puts "✅ Dashboard heading displayed correctly"

    # Welcome message
    assert_select "p", text: /Welcome, #{@user.email_address}!/
    puts "✅ Welcome message displayed correctly"
  end



end
