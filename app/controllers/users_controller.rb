class UsersController < ApplicationController
  def new
  end

  def create
    @new_user = User.create(user_params)
    if @new_user.save
      session[:user_id] = @new_user.id
      redirect_to "/profile"
    else
      flash[:error] = @new_user.errors.full_messages
      redirect_to '/register/new'
    end
  end

  def show
    if session[:user_id]
      @user = User.find(session[:user_id])
      flash[:success] = 'Logged In!'
    else
      render file: "/public/404"
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    @user.update(user_params)
    @user.save
    flash[:notice] = 'Profile Updated!'
    render :show
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
