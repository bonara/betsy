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
        
      describe "edit" do
        it "succeeds for an existing order_item ID" do
            order = Order.create
    
            product = Product.first
  
            order_item = OrderItem.create!(
                order_id: order.id, 
                product_id: product.id,
                quantity: 2
              )

          get edit_order_item_path(order_item.id)
    
          must_respond_with :success
        end
    
        # it "renders 404 not_found for a bogus order_item ID" do
        #   order_item_id = 987736
    
        #   get edit_order_item_path(order_item_id)
    
        #   must_respond_with :not_found
        # end
      end
    
    describe "destroy" do
        it 'removes a single order items from order' do
          
            order = Order.create
            product = Product.first

            order_item = OrderItem.create!(
                order_id: order.id, 
                product_id: product.id,
                quantity: 2
            )

          order_item = OrderItem.find_by(product_id: product.id, order_id: order.id)

          expect(order_item.quantity).must_equal 2

          delete order_item_path(order_item)

          puts order_item

          expect(order_item).must_be_nil
    
          must_respond_with :redirect
          must_redirect_to fallback_location: root_path
    
        end
    
        # it 'returns a 404 if the order does not exist' do
        #   order_item_id = 182939
    
        #   delete order_item_path(order_item_id)
    
        #   must_respond_with :not_found
    
        # end
      end

      describe 'update' do 
        it 'Can update an order item quantity in the cart' do
      
            order_item = OrderItem.first

            expect(order_item.quantity).must_equal 1

            order_hash = {
                order_item: {
                product_id: order_item.product.id,
                order_id: order_item.order.id,
                quantity: 3,
                }
            }

            patch order_item_path(order_item), params: order_hash

            order_item.reload

            expect(order_item.quantity).must_equal 3

            must_respond_with :redirect
            must_redirect_to(fallback_location: root_path)
    
        end
        
        # it 'Will not change quantity if the stock is less than quantity' do
    
        #   product = Product.first
    
        #   order_hash = {
        #     order_item: {
        #       product_id: product.id,
        #       quantity: 1,
        #     }
        #   }
    
        #   post orders_path, params: order_hash
          
        #   order_id = session[:order_id]
    
        #   order_item = OrderItem.find_by(order_id: order_id)
    
        #   order_item.quantity = 51
    
        #   order_item.save
    
        #   update_hash = {
        #     order: {
        #       status: 'paid',
        #       email: 'test@email.com',
        #       address: 'random address',
        #       name: 'Jack',
        #       cc_name: 'Jackie',
        #       cc_exp: 20190501,
        #       cc_num: 12345432112344321
        #     }
        #   }
    
        #   patch order_path(order_id), params: update_hash
    
        #   expect(order_item.product.stock).must_equal 50
    
        #   must_respond_with :bad_request
    
        # end
    end
    
    

#   describe 'update' do
#     it 'can update an item quantity' do
      # - We need to get an instance of an existing order item
             # use order item fixture 
      # - We need to define the new quantity: 5
      # - We need to update that instance of an existing order item with the new quantity defined above
      # - We need to confirm that it was updated:
      #    - Check the order item's quantity... it should equal the new quantity defined above: 5
      # - Check that the controller did all the right things with flash and redirect

#       order_item_data = {
#         order_item: {
#           quantity: '5',
#           product_id: 1
#         }
#       }
#       before = OrderItem.count

#       expect do
#         post order_items_path, params: order_item_data
#       end

#       expect(OrderItem.count).must_equal before + 1

#       expect(flash[:result_text]).must_include "Successfully updated #{@order_item.id} quantity"
#       must_respond_with :ok
#     end
#   end
end
