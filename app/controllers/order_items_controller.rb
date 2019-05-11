class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_item, only: [:edit, :update]

  def index
    @order_items = OrderItem.all
  end

  def edit; end

  def update
    @order_item = OrderItem.find(params[:id])
    @product = @order_item.product
    puts 'controller'
    puts params

    if @product.stock > order_item_params[:quantity].to_i
      @order_item.quantity = order_item_params[:quantity].to_i
      if @order_item.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated quantity"
        redirect_back(fallback_location: root_path)
        puts 'controller'
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = 'Could not update quantity'
        flash.now[:messages] = @order_item.errors.messages
        render :edit, status: :not_found
      end
    end
  end

# Delete specific order item
def destroy
  unless @order_item
    head :not_found
    return
  end
  @order_item.destroy
  redirect_back(fallback_location: root_path)  
end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    unless @order_item
      head :not_found
      return
    end
  end

end