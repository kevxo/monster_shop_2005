class Admin::DashboardController < Admin::BaseController
  def index
    @user = User.find(session[:user_id])
    @orders = Order.order(:status)
    flash[:success] = "Logged in as #{@user.name}"
  end
end
