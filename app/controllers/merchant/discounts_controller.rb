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

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      flash[:success] = "New Discount Created"
      redirect_to merchant_discounts_path
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    Discount.destroy(params[:id])
    flash[:notice] = "Discount deleted"
    redirect_to merchant_discount_path
  end

  private

  def discount_params
    params.require(:discount).permit(:percent, :item_quantity, :merchant_id)
  end
end
