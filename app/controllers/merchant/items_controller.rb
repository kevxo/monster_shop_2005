class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(id: current_user.merchant_id)
  end

  def update
    merchant = Merchant.find_by(id: current_user.merchant_id)
    item = Item.find(params[:item_id])
  end
end