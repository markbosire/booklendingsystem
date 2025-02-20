# test/views/sessions/new_test.rb
require "test_helper"

class SessionsNewTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @view_assigns = {} # Optional: Add any assigns needed for the view
  end

  test "renders decorative book icons correctly" do
    render template: "sessions/new"

    # Check if the decorative book icons are displayed correctly
    assert_select ".flex.justify-center.space-x-6.text-gray-400" do
      assert_select "i.bx-book-open"
      assert_select "i.bx-library"
      assert_select "i.bx-bookmark"
      puts "✅ Decorative book icons displayed correctly"
    end
  end

  test "renders flash alert message correctly" do
    flash[:alert] = "Invalid email or password"
    # Simulate a flash alert

    render template: "sessions/new", assigns: @view_assigns

    # Check if the alert message is displayed correctly
    assert_select "#alert" do
      assert_select "i.bx-error-circle"
      assert_select "p", text: "Invalid email or password"
      puts "✅ Flash alert message displayed correctly"
    end
  end

  test "renders flash notice message correctly" do
       flash[:notice] = "You have been logged out successfully"
    # Simulate a flash notice

    render template: "sessions/new", assigns: @view_assigns

    # Check if the notice message is displayed correctly
    assert_select "#notice" do
      assert_select "i.bx-check-circle"
      assert_select "p", text: "You have been logged out successfully"
      puts "✅ Flash notice message displayed correctly"
    end
  end

  test "renders sign-in form correctly" do
    render template: "sessions/new"

    # Check if the form is present and has the correct action
    assert_select "form[action=?]", session_url do
      # Check if the email field is present
      assert_select "input[type=email][name=?][required]", "email_address" do
        puts "✅ Email field displayed correctly"
      end

      # Check if the password field is present
      assert_select "input[type=password][name=?][required]", "password" do
        puts "✅ Password field displayed correctly"
      end

      # Check if the "Sign in" button is present
      assert_select "input[type=submit][value=?]", "Sign in" do
        puts "✅ Sign-in button displayed correctly"
      end
    end

    # Check if the "Forgot password?" link is present
    assert_select "a[href=?]", new_password_path, text: "Forgot password?" do
      puts "✅ Forgot password link displayed correctly"
    end

    # Check if the "Register Account" link is present
    assert_select "a[href=?]", new_registration_path, text: "Register Account" do
      puts "✅ Register Account link displayed correctly"
    end
  end
end
