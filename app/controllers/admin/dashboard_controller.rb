class Admin::DashboardController < Admin::BaseController
  def index
    flash[:success] = 'Logged In!'
  end
end