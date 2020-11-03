class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(id: current_user.merchant_id)
  end

  def update
    merchant = Merchant.find_by(id: current_user.merchant_id)
    item = Item.find(params[:item_id])
    item.update(activation_status: 'Deactivated')
    redirect_to '/merchant/items'
    flash[:success] = "Item was deactivated."
  end
end