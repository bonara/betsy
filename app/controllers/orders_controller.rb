class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Successfully added product to your cart"
      redirect_to order_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not add product to cart"
      flash[:messages] = @order.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    order_id = params[:id]
    @merchants = Merchant.all
    @merchant_order = @merchants.where(order_id: order_id)
  end

  def edit
    order_id = params[:id]
    @order = Order.find_by(id: order_id)
    redirect_to orders_path if @order.nil?
  end

  def update
    order_id = params[:id]
    order = Order.find(order_id)

    order.update(order_params)
    redirect_to order_path(order.id)
  end

  def destroy
    order_id = params[:id]
    order = Order.find_by(id: order_id)

    unless order
      head :not_found
      return
    end

    order.destroy

    redirect_to orders_path
  end
end

private

def order_params
  params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end
