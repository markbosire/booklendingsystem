class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  # Update app/controllers/books_controller.rb

def borrow
  @book = Book.find(params[:id])
  
  if @book.borrowings.where(due_date: Time.current..).exists?
    redirect_to @book, alert: "This book is already borrowed."
  else
    borrowing = @book.borrowings.build(user: Current.user, due_date: 2.weeks.from_now)
    
    if borrowing.save
      redirect_to @book, notice: "Book successfully borrowed. Due date: #{borrowing.due_date.strftime("%B %d, %Y")}"
    else
      redirect_to @book, alert: "Could not borrow this book: #{borrowing.errors.full_messages.join(", ")}"
    end
  end
end

def return
  @book = Book.find(params[:id])
  borrowing = @book.borrowings.find_by(user: Current.user, due_date: Time.current..)
  
  if borrowing
    borrowing.update(due_date: Time.current)
    redirect_to @book, notice: "Book successfully returned."
  else
    redirect_to @book, alert: "You haven't borrowed this book or it's already returned."
  end
end
end