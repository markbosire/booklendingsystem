require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper

  setup do
    @user = users(:one)  
    @book = books(:one) 
    @borrowing = borrowings(:one)  
  end

  test "should get user profile page" do
    login_as(@user)  # Sign in the user
    get user_path(@user)
    assert_response :success
    assert_select "h1", "User Profile"  # Check for the page title
    assert_select "p", /Email: #{@user.email_address}/  # Check for the user's email
    puts "✅ should get user profile page"
  end

  test "should display borrowed books" do
    login_as(@user)   # Sign in the user
    get user_path(@user)
    assert_response :success

    # Check if borrowed books are displayed
    if @user.borrowings.where("due_date > ?", Time.current).empty?
      assert_select "p", "No books currently borrowed."  # Check for the "no books" message
    else
      assert_select "h2", "Borrowed Books"  # Check for the borrowed books section title
      @user.borrowings.where("due_date > ?", Time.current).each do |borrowing|
        assert_select "h3", borrowing.book.title  # Check for the book title
        assert_select "p", /by #{borrowing.book.author}/  # Check for the book author
        assert_select "span", /Due: #{borrowing.due_date.strftime("%B %d, %Y")}/  # Check for the due date
      end
    end
    puts "✅ should display borrowed books"
  end

  test "should display return button for current user" do
   login_as(@user)   # Sign in the user
    get user_path(@user)
    assert_response :success

    # Check if the return button is displayed for the current user
    if @user.borrowings.where("due_date > ?", Time.current).any?
      assert_select "a", "Return Book"  # Check for the return button
    end
    puts "✅ should display return button for current user"
  end
end