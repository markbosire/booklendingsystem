class PagesController < ApplicationController
  allow_unauthenticated_access only: :home
  def home
    redirect_to dashboard_path if authenticated?
  end

 

def dashboard
  redirect_to new_session_path unless authenticated?
  @recent_books = Book.order(created_at: :desc).limit(12)
end


end
