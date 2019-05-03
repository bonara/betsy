class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
    order_id = params[:id]
    @order_items = OrderItems.all
    @order_order_items = @order_items.where(order_id: order_id)
  end

  def new
    @order = Order.new
  end

  def create
    if session[:order_id]
      order = Order.find_by(id: session[:order_id])
      if order.present?
        order_id = order.id
      else
        session[:order_id] = nil
      end
    end

    if session[:order_id] == nil
      @order = Order.create
      session[:order_id] = @order.id
    end

    @order.save
  end

  def edit
    order_id = params[:id]
    @order = Order.find_by(id: order_id)
    redirect_to order_path if @order.nil?
  end

  def update
    if @order.update(order_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated order #{@order.id}"
      redirect_to order_path(@order)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save order #{@order.id}"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @order.destroy
    session[:order_id] = nil
    flash[:status] = :success
    flash[:message] = "Successfully deleted order #{@order.id}"
    redirect_to orders_path
  end

end

private

def order_params
  params.require(:order).permit(:status, :email, :address, :name, :cc_name, :cc_exp, :cc_num)
end
