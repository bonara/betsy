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
  end

  describe 'create' do
    before do
      @product = products(:rings)
    end
    it 'can save a valid review' do
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
  end
end
