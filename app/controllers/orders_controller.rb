class OrdersController < ApplicationController
  skip_before_action :require_login

  def index
    @orders = Order.all
  end

  # this is the cart
  def show
    @order_id = params[:id]
    @order_items = OrderItems.all
    @order_order_items = @order_items.where(order_id: @order_id)
  end

  # def new
  #   @order = Order.new
  # end

  # add_to_cart
  def create
    if session[:order_id].nil?
      @order = Order.create(status: 'pending')
      session[:order_id] = @order.id
    else
      @order = Order.find_by(id: session[:order_id])
    end

    @product = Product.find(order_item_params[:product_id])

    if @product.stock < order_item_params[:quantity]
      flash.now[:status] = :failure
      flash.now[:result_text] = 'You have exceeded number of items in stock, please update the product quantity!'
      redirect_to product_path(@product)
    else
      @order_item = OrderItem.new(order_item_params.merge(order_id: @order.id))

      if @order_item.save
        @product.stock -= order_item_params[:quantity]
        @product.save
        flash[:status] = :success
        flash[:result_text] = 'Successfully added your product to cart'
        redirect_to product_path(@product)
      else
        flash.now[:status] = :failure
        flash[:result_text] = 'Could not add a product to cart'
        flash[:messages] = @order_item.errors.messages
        redirect_to product_path(@product)
      end
    end
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
