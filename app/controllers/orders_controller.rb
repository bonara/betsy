class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  # this is the cart
  def show
    order_id = params[:id]
    @order_items = OrderItems.all
    @order_order_items = @order_items.where(order_id: order_id)
  end

  def new
    @order = Order.new
  end

  # add_to_cart
  def create
    if session[:order_id] != nil
      @order = Order.create(status: 'incomplete')
      session[:order_id] = @order.id
    end

    @order_item = OrderItem.create(
      order_id: @order.id,
      product_id: params[:product_id],
      quantity: params[:quanity]
    )
  end

  # checkout
  def edit
    order_id = params[:id]
    @order = Order.find_by(id: order_id)
    redirect_to order_path if @order.nil?
  end

  # process payment
  def update
    if @order.update(order_params)
      @order.status = 'complete'
      flash[:status] = :success
      flash[:message] = 'Purchase successful'
      redirect_to order_confirmation_path(@order)
    else
      flash.now[:status] = :error
      flash.now[:message] = 'Purchase not successful'
      render :edit, status: :bad_request
    end
  end

  # Delete the whole cart
  def destroy
    @order.destroy
    session[:order_id] = nil
    flash[:status] = :success
    flash[:message] = 'Your cart is now empty'
    redirect_to products_path
  end

end

private

def order_params
  params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end

def order_item_params
  params.require(:order_item).permit(:quantity, :product_id)
end
