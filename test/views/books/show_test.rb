# test/views/books/show_test.rb
require "test_helper"

class BooksShowTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @book = books(:one)
    @user = users(:one)
    @view_assigns = { book: @book, current_user: @user }
  end

  test "renders book details and borrowing status correctly" do
    render template: "books/show", assigns: @view_assigns

    # Check if the book title is displayed correctly
    assert_select "h1", text: @book.title do
      puts "✅ Book title displayed correctly"
    end

    # Check if the book author is displayed correctly
    assert_select "p", text: /by #{@book.author}/ do
      puts "✅ Book author displayed correctly"
    end

    # Check if the book ISBN is displayed correctly
    assert_select "p", text: /ISBN: #{@book.isbn}/ do
      puts "✅ Book ISBN displayed correctly"
    end

    # Check if the borrowing status is displayed correctly
    if @book.borrowings.where("due_date > ?", Time.current).exists?
      borrowing = @book.borrowings.where("due_date > ?", Time.current).find_by(user: @user)
      if borrowing
        assert_select "span", text: /You have borrowed this book \(Due: #{borrowing.due_date.strftime("%B %d, %Y")}\)/ do
          puts "✅ Borrowing status displayed correctly for current user"
        end
      else
        assert_select "span", text: "Currently Borrowed by another user" do
          puts "✅ Borrowing status displayed correctly for another user"
        end
      end
    else
      assert_select "a", text: "Borrow Book" do
        puts "✅ Borrow book link displayed correctly"
      end
    end

    # Check if the "Back to Books" link is displayed correctly
    assert_select "a", text: "Back to Books" do
      puts "✅ Back to Books link displayed correctly"
    end

    # Check if the "Back to Dashboard" link is displayed correctly
    assert_select "a", text: "Back to Dashboard" do
      puts "✅ Back to Dashboard link displayed correctly"
    end
  end

  test "displays flash notice and alert messages correctly" do
     # Simulate a flash notice
     flash[:notice] = "Test notice"
    flash[:alert] = "Test alert"
    render template: "books/show", assigns: @view_assigns

    assert_select "p", text: "Test notice" do
      puts "✅ Flash notice displayed correctly"
    end


    render template: "books/show", assigns: @view_assigns

    assert_select "p", text: "Test alert" do
      puts "✅ Flash alert displayed correctly"
    end
  end
end
