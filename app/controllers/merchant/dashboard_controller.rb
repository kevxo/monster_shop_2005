class Merchant::DashboardController < Merchant::BaseController
  def index
    flash[:success] = 'Logged In!'
    @merchant = Merchant.find_by(id: current_user.merchant_id)
  end

  def items_index
    
  end
end
