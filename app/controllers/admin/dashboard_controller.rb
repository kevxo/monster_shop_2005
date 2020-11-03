class Admin::DashboardController < Admin::BaseController
  def index
    flash[:success] = 'Logged In!'
    @orders = Order.order(:status)
  end
end
