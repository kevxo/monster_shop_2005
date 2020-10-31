class SessionsController < ApplicationController
  def new
    if current_user
      flash[:error] = "You are already logged in"
      redirect_to '/profile' if current_user.default?
      redirect_to '/merchant' if current_user.merchant?
      redirect_to '/admin' if current_user.admin?
    end
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id
        if @user.role == 'default'
          redirect_to '/profile'
        elsif @user.role == 'merchant'
          redirect_to '/merchant'
        else
          redirect_to '/admin'
        end
      else
        flash[:error] = 'Credentials are incorrect'
        redirect_to '/login'
      end
    else
      flash[:error] = 'Account not found.'
      redirect_to '/register/new'
    end
  end

  def destroy
    # session.delete(:user_id)
    # User.find(session[:user_id]).destroy
    session[:user_id] = nil
    # reset_session
    flash[:success] = "You are now logged out"
    redirect_to '/'
  end
end
