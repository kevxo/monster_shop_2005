class UsersController < ApplicationController
  def new
  end

  def create
    @new_user = User.create(user_params)
    if @new_user.save
      session[:user_id] = @new_user.id
      flash[:success] = "You are now registered and logged in."
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
        @user.update(user_edit_params)
        if !@user.update(user_edit_params)
          flash[:error] = @user.errors.full_messages.to_sentence
          render :edit
        else
          flash[:notice] = 'Profile Updated!'
          render :show
        end
      else
        flash.now[:notice] = "Email is already in use."
        render :edit
      end
    else
      flash[:error] = @user.errors.full_messages.to_sentence
    end
  end

  def update_password
    @user = User.find(session[:user_id])
    if user_params[:password].blank?
      flash[:error] = "Password cannot be blank."
      user_params.delete(:password)
      render :password_edit
    elsif user_params[:password] == user_params[:password_confirmation]
      @user.update(user_params)
      @user.save
      flash[:notice] = "Password Updated!"
      redirect_to '/profile'
    elsif user_params[:password] != user_params[:password_confirmation]
      flash.now[:notice] = "Password and Confirmation do not match."
      render :password_edit
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :password_edit
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def user_edit_params
    params.permit(:name, :address, :city, :state, :zip, :email)
  end
end
