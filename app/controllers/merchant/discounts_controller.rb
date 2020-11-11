class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  private

  def discount_params
    params.require(:discount).permit(:percent, :item_quantity, :merchant_id)
  end
end
