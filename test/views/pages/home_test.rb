require "test_helper"

class HomePagesTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  test "renders home page correctly" do
    render template: "pages/home"

    # Test main container and its styling
    assert_select "div.min-h-screen.bg-gray-50.flex.items-center.justify-center" do
      puts "✅ Main container with correct styling classes found"
    end

    assert_select "div.max-w-2xl.text-center.space-y-8" do
      puts "✅ Content container with correct styling classes found"
    end

    # Test main heading
    assert_select "h1.text-4xl.md\\:text-5xl.font-bold.text-gray-800", text: "Welcome to the Book Lending System" do
      puts "✅ Main heading displayed correctly with proper styling"
    end

    # Test login button
    assert_select "a[href=?]", new_session_path do
      assert_select "i.bx.bx-log-in-circle.text-xl.mr-2" do
        puts "✅ Login icon displayed correctly"
      end
      assert_select "a", text: /Start Your Reading Journey/ do
        puts "✅ Login button text displayed correctly"
      end
    end

    # Test login button styling
    assert_select "a.inline-flex.items-center.px-6.py-3.text-lg.font-medium.text-white.bg-blue-600.rounded-lg" do
      puts "✅ Login button styling classes applied correctly"
    end

    # Test decorative book icons
    assert_select "div.mt-12.flex.justify-center.space-x-6.text-gray-400" do
      assert_select "i.bx.bx-book-open.text-4xl" do
        puts "✅ Book open icon displayed correctly"
      end
      assert_select "i.bx.bx-library.text-4xl" do
        puts "✅ Library icon displayed correctly"
      end
      assert_select "i.bx.bx-bookmark.text-4xl" do
        puts "✅ Bookmark icon displayed correctly"
      end
      puts "✅ Decorative icons container styled correctly"
    end
  end

  test "login button has correct hover and transition classes" do
    render template: "pages/home"

    assert_select "a[href=?]", new_session_path do
      assert_select "[class*='hover:bg-blue-700']" do
        puts "✅ Login button hover state class applied"
      end
      assert_select "[class*='transition-colors']" do
        puts "✅ Login button transition class applied"
      end
      assert_select "[class*='duration-300']" do
        puts "✅ Login button transition duration class applied"
      end
    end
  end

  test "page is responsive" do
    render template: "pages/home"

    # Test responsive padding
    assert_select "div.px-4" do
      puts "✅ Responsive padding applied"
    end

    # Test responsive text sizing
    assert_select "h1[class*='md:text-5xl']" do
      puts "✅ Responsive heading text size applied"
    end

    # Test minimum width constraint
    assert_select "div.min-w-screen" do
      puts "✅ Minimum width constraint applied"
    end
  end
end
