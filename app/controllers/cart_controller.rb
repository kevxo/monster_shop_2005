class CartController < ApplicationController
  before_action :reject_admin

  def reject_admin
    return unless current_admin?

    render file: '/public/404'
  end

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to '/items'
  end

  def show
    @items = cart.items
  end

  def add_quantity
    require 'pry' ; binding.pry
    redirect_to "/cart"
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end
end
