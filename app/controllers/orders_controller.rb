class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
    @order = @current_order
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(product_params)
    redirect_to orders_path
  end

  def destroy
    @order = @current_order
    @order.destroy
    session[:order_id] = nil
    redirect_to root_path
  end

  def create
    @current_order.order_items.each do |item|
      @order.order_items << item
      item.order_id = nil
    end
  end

  def checkout
    @order = Order.new(order_params)
    @current_order.order_items.each do |item|
      @order.order_items << item
      item.order_id = nil
    end
    @order.save
    Order.destroy(session[:order_id])
    session[:order_id] = nil
    redirect_to root_path
  end
end

private

def order_params
  params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end
