class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    render_404 unless @order

  end

  def new
    @order = Order.new
  end

  def create
    # Instantiate a new Order variable passing in the order params 
    @order = Order.new(order_params)
    #  Then before saving, iterate through the current_cart's order_items 
    #  and append them to the new order variable. 
    # Then remember to assign the cart_id of the order_item to nil 
    @current_cart.order_items.each do |item|
      @order.order_items << item
      item.cart_id = nil
    end
    # Save the order after appending all order_items from the cart
    @order.save
    # Destroy the cart and set the session[:cart_id] = nil as the 
    # and cart has been fulfilled and the user can start shopping 
    # for a new order. Redirect back to root_path
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
    redirect_to root_path
  end
end

private

def order_params
  params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end
