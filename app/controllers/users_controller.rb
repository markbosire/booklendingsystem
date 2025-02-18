class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @borrowed_books = @user.books
  end
end