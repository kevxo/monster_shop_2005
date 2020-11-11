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

  def new
    @discount = Discount.new
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      flash[:success] = "Discount Edited"
      redirect_to merchant_discount_path
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end
  
  private

  def discount_params
    params.require(:discount).permit(:percent, :item_quantity, :merchant_id)
  end
end
