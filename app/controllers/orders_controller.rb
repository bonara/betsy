# frozen_string_literal: true

class OrdersController < ApplicationController
  skip_before_action :require_login

  # this is the cart
  def index
    @order = Order.find_by(id: session[:order_id])
  end

  def new
    @order = Order.find_by(id: session[:order_id])
  end

  def show
    @order_order_items = OrderItem.where(order_id: session[:order_id])
  end

  # add_to_cart
  def create
    if session[:order_id].nil?
      @order = Order.create(status: 'pending')
      session[:order_id] = @order.id
    else
      @order = Order.find_by(id: session[:order_id])
    end

    @product = Product.find(params[:product][:product_id])

    if @product.stock < params[:quantity].to_i
      flash.now[:status] = :failure
      flash.now[:result_text] = 'You have exceeded number of items in stock, please update the product quantity!'
      redirect_to product_path(@product)
    else
      if @order.order_items.map(&:product_id).include?(@product.id)
        @order_item = @order.order_items.find_by(product_id: @product.id)
        @order_item.quantity += 1
      else
        @order_item = OrderItem.new(product_id: @product.id, order_id: @order.id, quantity: params[:quantity].to_i)
      end

      if @order_item.save
        @product.stock -= params[:quantity].to_i
        @product.save
        flash[:status] = :success
        flash[:result_text] = 'Successfully added your product to cart'
        redirect_to show_cart_path
      else
        flash.now[:status] = :failure
        flash[:result_text] = 'Could not add a product to cart'
        flash[:messages] = @order_item.errors.messages
        redirect_to products_path
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
    @order = Order.find_by(id: session[:order_id])
    if @order.update(order_params)
      @order.status = 'complete'
      flash[:status] = :success
      flash[:message] = 'Purchase successful'
      redirect_to products_path
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
  params.permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end
