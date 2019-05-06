class OrderItemsController < ApplicationController

  def index
    @order_item = OrderItem.all
  end

  # Delete specific order item
  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_to order_path(@order)
  end

  def create
    # Find associated product and order_id
    chosen_product = Product.find(params[:product_id])
    selected_order = @order

    # If cart already has this product then find the relevant line_item and iterate quantity otherwise create a new line_item for this product
    if current_cart.products.include?(chosen_product)
      # Find the line_item with the chosen_product
      @line_item = current_cart.line_items.find_by(:product_id => chosen_product)
      # Iterate the line_item's quantity by one
      @line_item.quantity += 1
    else
      @line_item = LineItem.new
      @line_item.cart = current_cart
      @line_item.product = chosen_product
    end

    # Save and redirect to cart show path
    @line_item.save
    redirect_to cart_path(current_cart)
    end
end

private

def order_item_params
  params.require(:order_item).permit(:quantity, :product_id)
end

