class UserOrdersController < ApplicationController
  def index
    flash[:notice] = "Order successfully created!"

    @user = User.find(session[:user_id])
    @orders = @user.orders
  end

  def show
    @user = User.find(session[:user_id])
    @order = @user.orders.find(params[:order_id])
  end

end
