class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def borrow
    @book = Book.find(params[:id])
    # Add logic to create a Borrowing record
  end

  def return
    @book = Book.find(params[:id])
    # Add logic to mark the book as returned
  end
end