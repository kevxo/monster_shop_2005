class Admin::MerchantsController < Admin::BaseController
  def index
    @admin = User.find(session[:user_id])
    @merchants = Merchant.all
  end

  def show
    @admin = User.find(session[:user_id])
    @merchant = Merchant.find(params[:id])
  end

  def update
    @admin = User.find(session[:user_id])
    @merchant = Merchant.find(params[:id])
    if @merchant.status == 'Enabled'
      @merchant.update(status: "Disabled")

      flash[:notice] = "Merchant #{@merchant.name} account is disabled."

      @merchant.deactivate_items
      @merchant.save
    elsif @merchant.status == 'Disabled'
      @merchant.update(status: "Enabled")

      flash[:notice] = "Merchant #{@merchant.name} account is enabled."

      @merchant.activate_items
      @merchant.save
    end

    redirect_to '/admin/merchants'
  end

end
