# test/controllers/books_controller_test.rb
require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper

  setup do
    @user = users(:one)  
    @book = books(:one) 
    
    login_as(@user)
  end

 
  
  test "should get index" do
    get books_path
    assert_response :success
    assert_select "h1", "Library Books"
  end
  
  test "should get show" do
    get book_path(@book)
    assert_response :success
    assert_select "h1", text: /#{@book.title}/
  end
  
  test "should get borrow" do
    get borrow_book_path(@book)
    assert_response :success
    assert_select "h3", "Confirm Borrowing"
  end
  
  test "should create borrowing" do
    assert_difference("Borrowing.count") do
      post create_borrowing_book_path(@book)
    end
    assert_redirected_to book_path(@book)
    assert_match /Book borrowed/, flash[:notice]
  end
  
  test "should not create borrowing for already borrowed book" do
    post create_borrowing_book_path(@book)

    assert_no_difference("Borrowing.count") do
      post create_borrowing_book_path(@book)
    end
    assert_redirected_to book_path(@book)
    assert_equal "This book is already borrowed.", flash[:alert]
  end
  
  test "should get return" do
    post create_borrowing_book_path(@book)
    
    get return_book_path(@book)
    assert_response :success
    assert_select "h3", "Confirm Return"
  end
  
  test "should complete return" do
    post create_borrowing_book_path(@book)

    post complete_return_book_path(@book)
    assert_redirected_to book_path(@book)
    assert_equal "Book returned.", flash[:notice]

    borrowing = @book.borrowings.find_by(user: @user)
    assert borrowing.due_date <= Time.current
  end
  
  test "should not complete return for non-borrowed book" do
    post complete_return_book_path(@book)
    assert_redirected_to book_path(@book)
    assert_equal "Could not return.", flash[:alert]
  end
end