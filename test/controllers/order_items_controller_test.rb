require 'test_helper'

describe OrderItemsController do
    # describe 'index' do
    #     it 'succeeds when there are order_items' do
    #       get root_path
    
    #       must_respond_with :success
    #     end
    
    #     it 'succeeds when there are no order_items' do
    #       OrderItem.all do |order_item|
    #         order_item.destroy
    #       end
    
    #       get root_path
    
    #       must_respond_with :success
    #     end
    # end
        
    
    # describe "destroy" do
    #     it 'removes a single order items from order' do
          
    #         order = Order.create
    #         product = Product.first

    #         order_item = OrderItem.create!(
    #             order_id: order.id, 
    #             product_id: product.id,
    #             quantity: 2
    #         )

    #       order_item = OrderItem.find_by(product_id: product.id, order_id: order.id)

    #       expect(order_item.quantity).must_equal 2

    #       delete order_item_path(order_item)

    #       order_item = OrderItem.where(id: order_item.id)

    #       expect(order_item.length).must_equal 0
    
    #       must_respond_with :redirect
    #       must_redirect_to root_path
    
    #     end
    
        # it 'returns a 404 if the order does not exist' do
        #   order_item_id = 182939
    
        #   delete order_item_path(order_item_id)
    
        #   must_respond_with :not_found
    
        # end
    #   end

    describe 'update' do 
        # it 'Can update an order item quantity in the cart' do
      
        #     order_item = OrderItem.first

        #     expect(order_item.quantity).must_equal 1

        #     order_hash = {
        #         order_item: {
        #         product_id: order_item.product.id,
        #         order_id: order_item.order.id,
        #         quantity: 3,
        #         }
        #     }

        #     patch order_item_path(order_item), params: order_hash

        #     order_item.reload

        #     expect(order_item.quantity).must_equal 3

        #     must_respond_with :redirect
        #     must_redirect_to root_path
    
        # end
        
            it 'Will not change quantity if the stock available is less than quantity' do
        
            order_item = OrderItem.first

            expect(order_item.quantity).must_equal 1

            puts order_item.product.stock

            order_hash = {
                order_item: {
                product_id: order_item.product.id,
                order_id: order_item.order.id,
                quantity: order_item.product.stock + 1,
                }
            }

            patch order_item_path(order_item), params: order_hash

            must_respond_with :not_found
        end
    end
end
