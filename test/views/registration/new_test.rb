require "test_helper"

class RegistrationsNewTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = User.new
    @view_assigns = { user: @user }
  end

  test "renders registration page structure correctly" do
    render template: "registrations/new", assigns: @view_assigns

    # Test main container and card
    assert_select "div.flex.justify-center.items-center.min-h-screen.bg-gray-100" do
      assert_select "div.w-full.max-w-md.p-6.bg-white.shadow-lg.rounded-xl" do
        puts "✅ Main container and card rendered correctly"
      end
    end

    # Test decorative icons
    assert_select "div.flex.justify-center.space-x-6.text-gray-400" do
      assert_select "i.bx.bx-book-open.text-4xl"
      assert_select "i.bx.bx-library.text-4xl"
      assert_select "i.bx.bx-bookmark.text-4xl"
      puts "✅ Decorative icons rendered correctly"
    end

    # Test heading
    assert_select "h1.font-extrabold.text-3xl.text-gray-800.mt-4.text-center", "Sign Up" do
      puts "✅ Sign Up heading rendered correctly"
    end
  end

  test "renders form fields correctly" do
    render template: "registrations/new", assigns: @view_assigns

    assert_select "form[action=?]", registration_path do
      # Email field
      assert_select "input[type=email][name='user[email_address]']" do |elements|
        element = elements.first
        assert_equal "username", element["autocomplete"]
        assert_equal "Enter your email address", element["placeholder"]
        assert element["required"]
        assert_match(/block.*rounded-lg.*border-gray-300/, element["class"])
        puts "✅ Email field rendered correctly"
      end

      # Password fields
      assert_select "input[type=password][name='user[password]']" do |elements|
        element = elements.first
        assert_equal "new-password", element["autocomplete"]
        assert_equal "Enter your password", element["placeholder"]
        assert_equal "72", element["maxlength"]
        assert element["required"]
        puts "✅ Password field rendered correctly"
      end

      assert_select "input[type=password][name='user[password_confirmation]']" do |elements|
        element = elements.first
        assert_equal "new-password", element["autocomplete"]
        assert_equal "Confirm your password", element["placeholder"]
        assert_equal "72", element["maxlength"]
        assert element["required"]
        puts "✅ Password confirmation field rendered correctly"
      end

      # Submit button
      assert_select "input[type=submit][value='Sign Up']" do |elements|
        element = elements.first
        assert_match(/bg-blue-600.*hover:bg-blue-500.*transition/, element["class"])
        puts "✅ Submit button rendered correctly"
      end
    end
  end

  test "renders flash messages when present" do
    flash[:alert] = "Test alert message"
    flash[:notice] = "Test notice message"

    render template: "registrations/new", assigns: @view_assigns

    assert_select "div#alert.bg-red-100.text-red-600" do
      assert_select "i.bx.bx-error-circle"
      assert_select "p", "Test alert message"
      puts "✅ Alert message rendered correctly"
    end

    assert_select "div#notice.bg-green-100.text-green-600" do
      assert_select "i.bx.bx-check-circle"
      assert_select "p", "Test notice message"
      puts "✅ Notice message rendered correctly"
    end
  end

  test "renders validation errors when present" do
    @user.errors.add(:email_address, "can't be blank")
    @user.errors.add(:password, "is too short")

    render template: "registrations/new", assigns: @view_assigns

    assert_select "div.bg-red-50.text-red-500" do
      assert_select "ul" do
        assert_select "li", "Email address can't be blank"
        assert_select "li", "Password is too short"
      end
      puts "✅ Validation errors rendered correctly"
    end
  end

  test "renders sign in link correctly" do
    render template: "registrations/new", assigns: @view_assigns

    assert_select "a[href=?]", new_session_path do
      assert_select "a.text-blue-600.hover\\:text-blue-500", text: "Already have an account? Sign in"
      puts "✅ Sign in link rendered correctly"
    end
  end

  test "form fields have correct focus and hover states" do
    render template: "registrations/new", assigns: @view_assigns

    # Test input focus states
    assert_select "input[class*='focus:ring-blue-500']"
    assert_select "input[class*='focus:border-blue-500']"
    puts "✅ Input focus states rendered correctly"

    # Test button hover states
    assert_select "input[class*='hover:bg-blue-500']"
    assert_select "input[class*='hover:scale-105']"
    puts "✅ Button hover states rendered correctly"
  end
end
