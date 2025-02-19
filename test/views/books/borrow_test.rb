# test/views/books/borrow_test.rb
require 'test_helper'

class BooksBorrowTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @book = books(:one)
    @user = users(:one)
    @borrowing = borrowings(:one)
    @view_assigns = { 
      book: @book, 
      borrowing: @borrowing,
      current_user: @user 
    }
  end

  test "renders borrow book page correctly" do
    render template: "books/borrow", assigns: @view_assigns

    assert_select "h1", text: "Borrow Book" do
      puts "✅ Page title displayed correctly"
    end

    # Book information section
    assert_select "div.bg-white" do
      assert_select "h2", text: @book.title do
        puts "✅ Book title displayed correctly: #{@book.title}"
      end

      assert_select "p", text: /by #{@book.author}/ do
        puts "✅ Book author displayed correctly: #{@book.author}"
      end

      assert_select "p", text: /ISBN: #{@book.isbn}/ do
        puts "✅ Book ISBN displayed correctly: #{@book.isbn}"
      end
    end

    # Confirmation section
    assert_select "h3", text: "Confirm Borrowing" do
      puts "✅ Confirmation section header displayed correctly"
    end

    assert_select "p", text: /You are about to borrow "#{@book.title}" by #{@book.author}/ do
      puts "✅ Borrowing confirmation message displayed correctly"
    end

    assert_select "p", text: /due on #{@borrowing.due_date.strftime("%B %d, %Y")}/ do
      puts "✅ Due date displayed correctly: #{@borrowing.due_date.strftime("%B %d, %Y")}"
    end

    # Action buttons
    assert_select "form[action=?][method=post]", create_borrowing_book_path(@book) do
      assert_select "button", text: "Confirm Borrowing" do
        puts "✅ Confirm borrowing button displayed correctly"
      end
    end

    assert_select "a[href=?]", book_path(@book), text: "Cancel" do
      puts "✅ Cancel link displayed correctly"
    end

    # Styling classes
    assert_select "div.mx-auto" do
      puts "✅ Main container styling applied correctly"
    end
    
    assert_select "div.md\\:w-2\\/3" do
      puts "✅ Responsive width styling applied correctly"
    end
  end

 
end