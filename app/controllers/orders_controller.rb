class OrdersController < ApplicationController
  skip_before_action :require_login
  def index
    @orders = Order.all
  end

  # this is the cart
  def show
    @order = Order.find_by(id: params[:id])
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

    if @product.stock < order_item_params[:quantity].to_i
      flash.now[:status] = :failure
      flash.now[:result_text] = 'You have exceeded number of items in stock, please update the product quantity!'
      redirect_to product_path(@product)
    else
      @order_item = OrderItem.new(order_item_params.merge(order_id: @order.id))

      if @order_item.save
        flash[:status] = :success
        flash[:result_text] = 'Successfully added your product to cart'
        redirect_to product_path(@product)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = 'Could not add a product to cart'
        flash.now[:messages] = @order_item.errors.messages
        redirect_to product_path(@product)
      end
    end
  end

  # checkout
  def edit
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end

  # process payment
  def update
    @order.order_items.each do |item|
      @purchased_product = Product.find_by(id: item.product_id)
      next unless @purchased_product.stock > item.quantity.to_i

      @purchased_product.stock -= item.quantity.to_i
      if @purchased_product.save
        @order.update_attributes(order_params)
        if @order.save
          @order.status = 'paid'
          @order.save
          flash[:status] = :success
          flash[:result_text] = 'Purchase successful'
          session[:order_id] = nil
          redirect_to root_path
        # redirect_to order_confirmation_path(@order)
        else
          flash.now[:status] = :failure
          flash.now[:result_text] = 'Purchase not successful'
          flash.now[:messages] = @order.errors.messages
          render :edit, status: :bad_request
        end
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "#{@purchased_product} has #{@purchased_product.stock} stock. Please update your cart"
      end
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

  private

  def order_params
    params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
  end

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
