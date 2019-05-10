# frozen_string_literal: true

require 'test_helper'

describe ReviewsController do
  describe 'new' do
    before do
      @product = products(:rings)
    end
    it 'can create a new review' do
      get new_product_review_path(@product)
      must_respond_with :success
    end

    it 'returns error if merchant tries to create a new review for their product' do
      merchant = merchants(:ada)
      perform_login(merchant)
      get new_product_review_path(@product)
      must_respond_with :redirect
    end
  end

  describe 'create' do
    it 'allows a user that is not product merchant leave a review' do
      @product = products(:rings)
      review_data = {
        review: {
          rating: 1,
          comment: 'Test'
        }
      }
      expect do
        post product_reviews_path(@product), params: review_data
      end.must_change 'Review.count', +1
    end

    it "return error if merchant reviews their own product" do
      merchant = merchants(:ada)
      perform_login(merchant)
      @product = products(:moon)
      review_data = {
        review: {
          rating: 5,
          comment: 'Merchant review'
        }
      }
      expect do
        post product_reviews_path(@product), params: review_data
      end.wont_change 'Review.count'
      must_respond_with :redirect
    end
  end
end
