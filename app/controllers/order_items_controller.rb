class OrderItemsController < ApplicationController

  def index
    @order_item = OrderItem.all
  end

  def new
    @order_item = OrderItem.new
  end

  # Delete specific order item
  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_to order_path(@order)
  end

  def create
    # Find associated product and current cart
    chosen_product = Product.find(params[:product_id])
    current_cart = session[:order_id]

    # If cart already has this product then find the relevant order_item and iterate quantity otherwise create a new order_item for this product
    if current_cart.products.include?(chosen_product)
      # Find the order_item with the chosen_product
      @order_item = current_cart.order_items.find_by(product_id: chosen_product)
      # Iterate the order_item's quantity by one
      @order_item.quantity += 1
    else
      @order_item = OrderItem.new
      @order_item.cart = current_cart
      @order_item.product = chosen_product
    end

    # Save and redirect to order show path
    @order_item.save
    redirect_to order_path(current_cart)
  end

  def add_quantity
    @order_item = OrderItem.find(params[:id])
    @order_item.quantity += 1
    @order_item.save
    redirect_to order_path(@order)
  end

  def reduce_quantity
    @order_item = OrderItem.find(params[:id])
    @order_item.quantity -= 1 if @order_item.quantity > 1
    @order_item.save
    redirect_to order_path(@order)
  end

end

private

def order_item_params
  params.require(:order_item).permit(:quantity, :product_id, :order_id)
end

