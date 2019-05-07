class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_item, only: %i[show edit update]
  def index
    @order_items = OrderItem.all
  end

  def show; end

  def edit; end

  def update
    @order_item.update_attributes(order_item_params)
    if @order_item.save
      flash.now[:status] = :success
      flash.now[:result_text] = "Successfully updated #{@order_item.id}"
      render
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = 'Could not update product'
      flash.now[:messages] = @order_item.errors.messages
      render :edit, status: :not_found
    end
  end

  def new
    @order_item = OrderItem.new
  end

# Delete specific order item
  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    render_404 unless @order_item
  end
end