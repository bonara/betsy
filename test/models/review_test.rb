require "test_helper"

describe Review do
  describe 'relations' do
    it 'has a product' do
      review = reviews(:one)
      review.must_respond_to :product
    end
  end

  describe 'validations' do
    it 'requires a rating' do
      review = Review.new
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end
    it 'return an error for 0 rating ' do
      review = Review.new(rating: 0)
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end
    it 'requires a rating between 1-5' do
      review = Review.new(rating: 3, product: (products(:moon)))
      review.valid?.must_equal true
    end
  end
end
