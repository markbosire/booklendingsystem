class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Custom validation logic
    if user_params[:password].blank?
      @user.errors.add(:password, "can't be blank")
    elsif user_params[:password_confirmation] != user_params[:password]
      @user.errors.add(:password_confirmation, "doesn't match Password")
    elsif !valid_email?(user_params[:email_address])
      @user.errors.add(:email_address, "is invalid")
    end

    if @user.errors.empty? && @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "Successfully signed up!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def valid_email?(email)
    # Simple email format validation
    email =~ URI::MailTo::EMAIL_REGEXP
  end
end
