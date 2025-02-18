class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  # app/controllers/books_controller.rb

def borrow
  @book = Book.find(params[:id])
  
  if @book.borrowings.where("due_date > ?", Time.current).exists?
    redirect_to @book, alert: "This book is already borrowed."
  else
    @borrowing = @book.borrowings.build(user: Current.user, due_date: 2.weeks.from_now)
  end
end

def create_borrowing
  @book = Book.find(params[:id])
  
  if @book.borrowings.where("due_date > ?", Time.current).exists?
    redirect_to @book, alert: "This book is already borrowed."
  else
    borrowing = @book.borrowings.create(user: Current.user, due_date: 2.weeks.from_now)
    
    if borrowing.persisted?
      redirect_to @book, notice: "Book borrowed. Due: #{borrowing.due_date.to_fs(:long)}"
    else
      redirect_to @book, alert: "Error: #{borrowing.errors.full_messages.join(', ')}"
    end
  end
end

def return
    @book = Book.find(params[:id])
    # Find active borrowings for the current user
    @borrowing = @book.borrowings.where("due_date > ?", Time.current).find_by(user: Current.user)
    
    if @borrowing
      # Render the return confirmation view
      render :return
    else
      redirect_to @book, alert: "Not borrowed or already returned."
    end
  end

  def complete_return
    @book = Book.find(params[:id])
    borrowing = @book.borrowings.where("due_date > ?", Time.current).find_by(user: Current.user)
    
    if borrowing
      borrowing.update(due_date: Time.current)
      redirect_to @book, notice: "Book returned."
    else
      redirect_to @book, alert: "Could not return."
    end
  end
end