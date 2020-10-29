class Merchant::DashboardController < Merchant::BaseController
  def index
    flash[:success] = 'Logged In!'
  end
end