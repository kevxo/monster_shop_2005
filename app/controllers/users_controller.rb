class UsersController < ApplicationController
  def new
  end

  def create
    @new_user = User.create(user_params)
    if @new_user.save
      flash[:success] = "You are now registered and logged in!"
      session[:user_id] = @new_user.id
      redirect_to "/profile"
    else  
      flash[:error] = "Please fill in all required fields."
      redirect_to '/register/new'
    end 
  end
  
  def show
    @user = User.find(session[:user_id])
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end