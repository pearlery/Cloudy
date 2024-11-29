class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Account created successfully!"
      redirect_to login_path
    else
      flash.now[:alert] = "Failed to create account. Please check your input."
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    session.delete(:user_id)
    flash[:notice] = "Logged out successfully."
    redirect_to login_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
