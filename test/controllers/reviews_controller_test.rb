# frozen_string_literal: true

require 'test_helper'

describe ReviewsController do
  describe 'new' do
    it 'sends a success message when a review has been created' do
      get new_product_review_path(Product.first.id)
      must_respond_with :success
    end

  describe 'create' do
    it "redirects to product's page when saving a review" do
      Review.count.must_equal 2
      proc {
        post product_reviews_path(products(:planetxyz).id), params: {
          review: {
            text_review: 'Another review is here.',
            rating: 2,
            product_id: products(:planetxyz).id
          }
        }
      }.must_change 'Review.count', 1

      must_respond_with :redirect
      must_redirect_to product_path(products(:planetxyz).id)
    end

    it 'does not allow a review not between 1 and 5' do
      invalid_review_data = {
        review: {
          rating: 100,
          product_id: Product.first.id
        }
      }
      Review.new(invalid_review_data[:review]).wont_be :valid?
      start_review_count = Review.count
      post product_reviews_path(invalid_review_data[:review][:product_id]), params: invalid_review_data
      must_respond_with :bad_request
      Review.count.must_equal start_review_count
    end
  end
end
