# frozen_string_literal: true

require 'test_helper'

describe Review do
  let(:review) { reviews(:one) }

  describe 'the review is valid' do
    it 'should return false without a rating' do
      review = Review.new
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end

    it 'should return false if rating is not between 1 and 5' do
      review.rating = 'no'
      review.valid?.must_equal false
    end
  end

  describe '#product' do
    it 'should return the correct product' do
      review = reviews(:one)
      review.must_respond_to :product
    end

    it 'should return the correct number of reviews' do
      reviews.count.must_equal 2
    end
  end
end
