# test/views/users/show_test.rb
require "test_helper"

class UsersShowTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:one)
    @view_assigns = { user: @user, current_user: @user }
  end



  test "renders user profile and borrowed books correctly" do
    render template: "users/show", assigns: @view_assigns

    assert_select "p", text: /Email: #{@user.email_address}/ do
      puts "✅ User email displayed correctly"
    end

    assert_select "h2", text: "Borrowed Books" do
      puts "✅ Borrowed books section displayed correctly"
    end

    @user.borrowings.where("due_date > ?", Time.current).each do |borrowing|
      assert_select "h3", text: borrowing.book.title do
        puts "✅ Borrowed book title displayed correctly: #{borrowing.book.title}"
      end
      assert_select "p", text: /by #{borrowing.book.author}/ do
        puts "✅ Borrowed book author displayed correctly: #{borrowing.book.author}"
      end
      assert_select "span", text: /Due: #{borrowing.due_date.strftime("%B %d, %Y")}/ do
        puts "✅ Borrowed book due date displayed correctly: #{borrowing.due_date.strftime("%B %d, %Y")}"
      end
    end

    assert_select "a", text: "Back to Dashboard" do
      puts "✅ Back to dashboard link displayed correctly"
    end
  end

require "test_helper"

class UsersShowTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:one)
    @view_assigns = { user: @user, current_user: @user }
  end

  test "renders user profile and borrowed books correctly" do
    render template: "users/show", assigns: @view_assigns

    assert_select "p", text: /Email: #{@user.email_address}/ do
      puts "✅ User email displayed correctly"
    end

    assert_select "h2", text: "Borrowed Books" do
      puts "✅ Borrowed books section displayed correctly"
    end

    @user.borrowings.where("due_date > ?", Time.current).each do |borrowing|
      assert_select "h3", text: borrowing.book.title do
        puts "✅ Borrowed book title displayed correctly: #{borrowing.book.title}"
      end

      assert_select "p", text: /by #{borrowing.book.author}/ do
        puts "✅ Borrowed book author displayed correctly: #{borrowing.book.author}"
      end

      assert_select "span", text: /Due: #{borrowing.due_date.strftime("%B %d, %Y")}/ do
        puts "✅ Borrowed book due date displayed correctly: #{borrowing.due_date.strftime("%B %d, %Y")}"
      end
    end

    assert_select "a", text: "Back to Dashboard" do
      puts "✅ Back to dashboard link displayed correctly"
    end
  end

  test "displays no books message when no books are borrowed" do
    # Create a new user instead of using fixture
    user_without_books = User.create!(
      email_address: "no_books@example.com",
      password: "password123"
    )

    @view_assigns = { user: user_without_books, current_user: user_without_books }
    render template: "users/show", assigns: @view_assigns

    assert_select "p", text: "No books currently borrowed." do
      puts "✅ No borrowed books message displayed correctly"
    end
  end
end
end
