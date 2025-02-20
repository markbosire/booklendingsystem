# test/views/books/index_test.rb
require "test_helper"

class BooksIndexTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:one)
    @books = [ books(:one), books(:two) ]
    @borrowing = borrowings(:one)



    @view_assigns = {
      books: @books,
      borrowing: @borrowing,
      current_user: @user
    }
  end

  test "renders books index page with all elements" do
    # Set up flash messages
    flash[:notice] = "Test notice"
    flash[:alert] = "Test alert"

    render template: "books/index", assigns: @view_assigns

    assert_select "h1", text: "Library Books" do
      puts "✅ Page title displayed correctly"
    end

    assert_select "a[href=?]", dashboard_path, text: "Back to Dashboard" do
      puts "✅ Dashboard link displayed correctly"
    end

    # Test flash messages
    assert_select "p.bg-green-50", text: "Test notice" do
      puts "✅ Success flash message displayed correctly"
    end

    assert_select "p.bg-red-50", text: "Test alert" do
      puts "✅ Alert flash message displayed correctly"
    end

    # Test book grid
    assert_select "div.grid" do
      puts "✅ Books grid container present"
    end

    @books.each do |book|
      assert_select "div.bg-white" do
        assert_select "h2", text: book.title do
          puts "✅ Book title displayed correctly: #{book.title}"
        end

        assert_select "p", text: /by #{book.author}/ do
          puts "✅ Book author displayed correctly: #{book.author}"
        end

        assert_select "p", text: /ISBN: #{book.isbn}/ do
          puts "✅ Book ISBN displayed correctly: #{book.isbn}"
        end

        assert_select "a[href=?]", book_path(book), text: "View Details" do
          puts "✅ View Details link displayed correctly for #{book.title}"
        end
      end
    end
  end

  test "displays correct borrowing status for books" do
    # Book borrowed by current user
    @borrowing.update!(user: @user, due_date: 2.week.from_now)

    # Book borrowed by another user
    other_borrowing = borrowings(:two)
    other_borrowing.update!(user: users(:two), due_date: 2.week.from_now)

    render template: "books/index", assigns: @view_assigns

    # Test book borrowed by another user
    assert_select "span.bg-red-100", "Borrowed by another user" do
      puts "✅ 'Borrowed by another user' status displayed correctly"
    end

    # Reset borrowings to test available status
    @borrowing.update!(due_date: 1.day.ago)
    other_borrowing.update!(due_date: 1.day.ago)

    render template: "books/index", assigns: @view_assigns

    assert_select "span.bg-green-100", "Available" do
      puts "✅ 'Available' status displayed correctly"
    end
  end

  test "renders without flash messages when not present" do
    render template: "books/index", assigns: @view_assigns

    assert_select "p.bg-green-50", count: 0 do
      puts "✅ No success flash message displayed when not present"
    end

    assert_select "p.bg-red-50", count: 0 do
      puts "✅ No alert flash message displayed when not present"
    end
  end
end
