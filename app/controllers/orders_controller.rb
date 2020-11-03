class OrdersController < ApplicationController
  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
    order.remove_quantity
  end

  private

  def order_params
    params[:user_id] = current_user.id
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
