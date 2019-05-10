# frozen_string_literal: true

require 'test_helper'

describe ReviewsController do
  let(:product) { Product.first }
  describe 'new' do
    it 'can create a new review' do
      get new_product_review_path(product)
      must_respond_with :success
    end
  end

  describe 'create' do
    it "can save a valid review" do 
      review_date = {
        review: {
          product_id: 5,
          rating: 1,
          user_id: 4
        }
      }
      test_review = Review.new(review_data[:review])
      test_review.must_respond_with :success
    end
  
    describe 'new' do 
    it 'does not allow a user to leave a review on their own product' do
      # There is a logged in user
      user = users(:ada)
      perform_login(user)
    
      #That logged in user has a product 
      id = product(:Honeymoon).id

      # That logged in user submits a review 
      review_hash = { review: { comment: review.comment, rating: review.rating }}
    
      expect {
        post product_reviews_path(id) params: review_hash
      }.wont_change 'Review.count'
    
      must_redirect_to product_reviews_path

      # Will flash message that you can't review your own products 
      expect(flash[:message]).must_equal 'You cannot review your own product.'
    end 
  end
end




# #     review_data = {
# #       review: {
# #         product_id: 3,
# #         rating: '5',
# #         user_id: 1
# #       }
# #     }

# #     merchant_id = Product.find_by(id: 3)

# #     expect do
# #       post create_product_review_path, params: review_data
# #     end

# #     if merchant_id == 1
# #       must_respond_with :failure

# #     else
# #       must_respond_with :success
# #     end
# #   end
# # end

# it 'does not allow a user to leave a review on their own product' do
#   user = users(:name)
#   perform_login(user)

#   id = product(:1).id
#   review_hash = { review: { comment: review.comment, rating: review.rating }}

#   expect {
#     post product_reviews_path(id) params: review_hash
#   }.wont_change 'Review.count'

#   must_redirect_to product_reviews_path
#   expect(flash[:message]).must_equal 'You cannot review your own product.'
# end 
# end
