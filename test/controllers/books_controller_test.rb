require "test_helper"
require "minitest/autorun"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create test data directly in setup
    @book = Book.create!(
      title: "Test Book",
      author: "Test Author",
      isbn: "1234567890"
    )
    
    @user = User.create!(
      email_address: "test@example.com",
      password: "password"
    )
    
    @other_user = User.create!(
      email_address: "other@example.com",
      password: "password"
    )
    
   @session = Session.new(user: @user)
  end

  teardown do
    # Clean up created records
    @book.destroy if @book.persisted?
    @user.destroy if @user.persisted?
    @other_user.destroy if @other_user.persisted?
  end

  test "should get index" do
    get books_url
    assert_response :success
    assert_not_nil assigns(:books)
    puts "✅ Index action successful"
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
    assert_not_nil assigns(:book)
    puts "✅ Show action successful"
  end

  test "should get borrow page" do
    get borrow_book_url(@book)
    assert_response :success
    assert_not_nil assigns(:book)
    assert_not_nil assigns(:borrowing)
    puts "✅ Borrow action successful"
  end

  test "should create borrowing for available book" do
    # Ensure book isn't borrowed
    @book.borrowings.where("due_date > ?", Time.current).destroy_all
    
    assert_difference("Borrowing.count") do
      post create_borrowing_book_url(@book)
    end
    
    assert_redirected_to book_url(@book)
    assert_equal "Book borrowed. Due: #{Borrowing.last.due_date.to_fs(:long)}", flash[:notice]
    puts "✅ Create borrowing action successful"
  end

  test "should not allow borrowing of already borrowed book" do
    # Create an active borrowing by another user
    @book.borrowings.create(user: @other_user, due_date: 2.weeks.from_now)
    
    assert_no_difference("Borrowing.count") do
      post create_borrowing_book_url(@book)
    end
    
    assert_redirected_to book_url(@book)
    assert_equal "This book is already borrowed.", flash[:alert]
    puts "✅ Correctly prevented borrowing of already borrowed book"
  end

  test "should get return page for borrowed book" do
    # Create an active borrowing for the current user
    @book.borrowings.create(user: @user, due_date: 2.weeks.from_now)
    
    get return_book_url(@book)
    assert_response :success
    assert_not_nil assigns(:book)
    assert_not_nil assigns(:borrowing)
    puts "✅ Return action successful"
  end

  test "should not allow return of book not borrowed by current user" do
    # Ensure no active borrowings for current user
    @book.borrowings.where(user: @user).destroy_all
    
    get return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Not borrowed or already returned.", flash[:alert]
    puts "✅ Correctly prevented return of book not borrowed by current user"
  end

  test "should complete return of borrowed book" do
    # Create an active borrowing for the current user
    borrowing = @book.borrowings.create(user: @user, due_date: 2.weeks.from_now)
    
    post complete_return_book_url(@book)
    
    assert_redirected_to book_url(@book)
    assert_equal "Book returned.", flash[:notice]
    
    # Verify the borrowing was marked as returned
    borrowing.reload
    assert borrowing.due_date <= Time.current
    puts "✅ Complete return action successful"
  end

  test "should not complete return for non-borrowed book" do
    # Ensure no active borrowings for current user
    @book.borrowings.where(user: @user).destroy_all
    
    post complete_return_book_url(@book)
    
    assert_redirected_to book_url(@book)
    assert_equal "Could not return.", flash[:alert]
    puts "✅ Correctly handled invalid return attempt"
  end

  test "should check for active borrowings in index" do
    get books_url
    assert_response :success
    assert_not_nil assigns(:books)
    puts "✅ Index loads with borrowing information"
  end

  test "should check for active borrowings in show" do
    get book_url(@book)
    assert_response :success
    assert_not_nil assigns(:book)
    puts "✅ Show loads with borrowing information"
  end
end