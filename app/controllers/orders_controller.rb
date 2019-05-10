class OrdersController < ApplicationController
  skip_before_action :require_login
  before_action :find_order, only: [:show, :edit, :destroy]

  def index
    @orders = Order.all
  end

  # this is the cart
  def show; end

  # checkout
  def edit; end
  
  def new; end

  # add_to_cart
  def create
    if session[:order_id].nil?

      @order = Order.create(status: 'pending')
      session[:order_id] = @order.id
    else
      @order = Order.find_by!(id: session[:order_id])
    end

    @product = Product.find(order_item_params[:product_id])

    if @product.stock < order_item_params[:quantity].to_i
      flash[:status] = :failure
      flash[:result_text] = 'You have exceeded number of items in stock!'
      redirect_back(fallback_location: root_path)
    else
      if @order.order_items.map(&:product_id).include?(@product.id)
        @order_item = @order.order_items.find_by(product_id: @product.id)
        @order_item.quantity += order_item_params[:quantity].to_i
      else
        @order_item = OrderItem.new(order_item_params.merge(order_id: @order.id))
      end

      if @order_item.save
        flash[:status] = :success
        flash[:result_text] = 'Successfully added your product to cart'
        redirect_back(fallback_location: root_path)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = 'Could not add a product to cart'
        flash.now[:messages] = @order_item.errors.messages
        redirect_back(fallback_location: root_path)
      end
    end
  end


  # process payment
  def update
    @order.transaction do
      @order.order_items.each do |item|
        @purchased_product = Product.find_by(id: item.product_id)
        if @purchased_product.stock >= item.quantity.to_i
          @purchased_product.stock -= item.quantity.to_i
          @purchased_product.save
        else
          flash.now[:status] = :failure
          flash.now[:result_text] = "#{@purchased_product} has #{@purchased_product.stock} stock. Please update your cart"
          render :edit, status: :bad_request
          return
        end
      end

      @order.update_attributes(order_params)
      @order.status = 'paid'
      if @order.save!
        flash[:status] = :success
        flash[:result_text] = 'Purchase successful'
        session[:order_id] = nil
        redirect_to confirmation_path(@order.id)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = 'Purchase not successful'
        flash.now[:messages] = @order.errors.messages
        render :edit, status: :bad_request
      end
    end
  end

  def confirmation
    @paid_order = Order.find_by(id: params[:id])
  end

  # Empty the cart
  def destroy
    unless @order
      head :not_found
      return
    end
    @order.order_items.destroy_all
    flash[:status] = :success
    flash[:result_text] = 'Your cart is now empty'
    
    redirect_back(fallback_location: root_path)  
  end

end

private

def order_params
  params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end

def order_item_params
  params.require(:order_item).permit(:quantity, :product_id)
end

def find_order
  @order = Order.find_by(id: params[:id])
  unless @order
    head :not_found
    return
  end
end
