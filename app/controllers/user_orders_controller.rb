class UserOrdersController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @orders = @user.orders

    flash[:notice] = "Order successfully created!"
  end

  def show
    @user = User.find(session[:user_id])
    @order = @user.orders.find(params[:order_id])
  end

  def update
    @user = User.find(session[:user_id])
    @order = @user.orders.find(params[:order_id])
    @order.return_quantity

    @order.update(status: "Cancelled")
    redirect_to "/profile"
    flash[:notice] = "You have successfully cancelled your order"
  end

end
