require "model_test_helper"

class BookTest < ActiveSupport::TestCase
  def setup
    @book = Book.new(title: "Test Book", author: "John Doe", isbn: "1234567890")
  end

  test "book should be valid" do
    assert @book.valid?
    puts "✅ Book is valid"
  end

  test "title should be present" do
    @book.title = ""
    assert_not @book.valid?, "Book is valid without a title"
    puts "✅ Title presence validation works"
  end

  test "author should be present" do
    @book.author = ""
    assert_not @book.valid?, "Book is valid without an author"
    puts "✅ Author presence validation works"
  end

  test "isbn should be present" do
    @book.isbn = ""
    assert_not @book.valid?, "Book is valid without an ISBN"
    puts "✅ ISBN presence validation works"
  end

  test "isbn should be unique" do
    @book.save
    duplicate_book = Book.new(title: "Another Book", author: "Jane Doe", isbn: "1234567890")
    assert_not duplicate_book.valid?, "Book is valid with a duplicate ISBN"
    puts "✅ ISBN uniqueness validation works"
  end
end
