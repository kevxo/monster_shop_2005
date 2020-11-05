class Merchant::DashboardController < Merchant::BaseController
  def index
    @user = User.find(session[:user_id])
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    flash[:success] = "Logged in as #{@user.name}"
  end
end
