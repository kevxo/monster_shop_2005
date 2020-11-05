class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:id])
  end

  def update
    @item_order = ItemOrder.find(params[:id])
    @item_order.item.update(inventory: (@item_order.item.inventory - @item_order.quantity))
    @item_order.fulfilled = true
    @item_order.save
    @item_order.item.save
    flash[:notice] = "#{@item_order.id} has been fulfilled."
    redirect_to "/merchant/orders/#{@item_order.order_id}"
  end
end
