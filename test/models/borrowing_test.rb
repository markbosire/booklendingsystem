require "model_test_helper"

class BorrowingTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email_address: "john@example.com", password: "password")
    @book = Book.create!(title: "Test Book", author: "John Doe", isbn: "1234567890")
    @borrowing = Borrowing.new(user: @user, book: @book, due_date: Date.today + 14.days)
  end

  # Test if the borrowing record is valid
  test "borrowing should be valid" do
    assert @borrowing.valid?
    puts "✅ Borrowing is valid with user, book, and due date"
  end

  # Test presence validation for user
  test "borrowing should have a user" do
    @borrowing.user = nil
    assert_not @borrowing.valid?, "Borrowing is valid without a user"
    puts "✅ Borrowing requires a user"
  end

  # Test presence validation for book
  test "borrowing should have a book" do
    @borrowing.book = nil
    assert_not @borrowing.valid?, "Borrowing is valid without a book"
    puts "✅ Borrowing requires a book"
  end

  # Test presence validation for due date
  test "borrowing should have a due date" do
    @borrowing.due_date = nil
    assert_not @borrowing.valid?, "Borrowing is valid without a due date"
    puts "✅ Borrowing requires a due date"
  end
end
