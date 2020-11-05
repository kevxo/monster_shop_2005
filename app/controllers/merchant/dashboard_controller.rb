class Merchant::DashboardController < Merchant::BaseController
  def index
    flash[:success] = 'Logged In!'
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    @order =  Order.find(@merchant.item_orders.pluck(:order_id))
  end
end
