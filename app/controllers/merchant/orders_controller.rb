class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item_order = ItemOrder.find_by(item_id: params[:id])
    @item.fill_status = "Fulfilled"
    @item.update(inventory: (@item.inventory - @item_order.quantity))
    @item.save
    flash[:notice] = "#{@item_order.id} has been fulfilled."
    redirect_to "/merchant/orders/#{@item_order.order_id}"
  end
end
