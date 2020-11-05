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
      flash[:success] = "Logged in as #{@user.name}"
    else
      render file: "/public/404"
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def password_edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if user_params[:name]
      if @user.email == user_params[:email] || !User.where(email: user_params[:email])
        @user.update(user_params)
        @user.save
        flash[:notice] = 'Profile Updated!'
        render :show
      else
        flash.now[:notice] = "Email is already in use."
        render :edit
      end
    else
      if user_params[:password] == user_params[:password_confirmation]
        @user.update(user_params)
        @user.save
        flash.now[:notice] = "Password Updated!"
        render :show
      else
        flash.now[:notice] = "Password and Confirmation do not match."
        render :password_edit
      end
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
