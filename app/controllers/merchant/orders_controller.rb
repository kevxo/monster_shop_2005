class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:order_id])
  end

  def update
    @order = Order.find(params[:order_id])
    @item_order = ItemOrder.find(params[:id])
    @item_order.item.update(inventory: (@item_order.item.inventory - @item_order.quantity))
    @item_order.update(fulfilled: true)
    @order.change_status
    flash[:notice] = "#{@item_order.id} has been fulfilled."
    redirect_to "/merchant/orders/#{@item_order.order_id}"
  end
end
