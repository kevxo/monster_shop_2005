class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(email: params[:email])
    session[:user_id] = @user.id
    if @user.role == 'default'
      redirect_to '/profile'
    elsif @user.role == 'merchant'
      redirect_to '/merchant'
    else
      redirect_to '/admin'
    end
  end
end