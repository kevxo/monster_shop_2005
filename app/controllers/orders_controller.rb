class OrdersController < ApplicationController
  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      cart.items.each do |item,quantity|
        @order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/profile/orders"
     #  item_order = ItemOrder.find_by(order_id: order.id)
     # order.items.each do |item|
     #   item.decrement_inventory(item_order.quantity)
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  private

  def order_params
    params[:user_id] = current_user.id
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
