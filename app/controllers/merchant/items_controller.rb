class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(id: current_user.merchant_id)
  end

  def update
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    item = Item.find(params[:item_id])
    if item.activation_status == 'Deactivated'
      item.update(activation_status: 'Activated')
      flash[:success] = "#{item.name} was activated."
    else
      item.update(activation_status: 'Deactivated')
      flash[:success] = "#{item.name} was deactivated."
    end 
      redirect_to '/merchant/items'
  end
end