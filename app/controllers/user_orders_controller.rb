class UserOrdersController < ApplicationController
  def index
    flash[:notice] = "Order successfully created!"

    @user = User.find(session[:user_id])
    @orders = Order.all
  end
end
