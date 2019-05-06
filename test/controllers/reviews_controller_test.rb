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
end
