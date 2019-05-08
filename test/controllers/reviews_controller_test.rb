# frozen_string_literal: true

require 'test_helper'

describe ReviewsController do
  describe 'new' do
    it 'returns success when making a new review' do
      get new_product_review_path(name: 'Jupiter Tour')
      must_respond_with :success
    end

    it "returns not found when a reviewed product doesn't exist" do
      get new_product_review_path(name: 'Canada Trip')
      must_respond_with :not_found
    end
  end

  # describe 'create' do
  #   it "redirects to product's page when saving a review" do
  #     Review.count.must_equal 2
  #     proc {
  #       post product_reviews_path params: {
  #         review: {
  #           comment: 'This is another review that will be created',
  #           rating: 2,
  #           product1 = Product.new(name: name, comment: ok)
  #         }
  #       }
  #     }.must_change 'Review.count', 1
  #     must_respond_with :redirect
  #     must_redirect_to product_path
  #   end
  # end
end
