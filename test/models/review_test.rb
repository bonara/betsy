# frozen_string_literal: true

require 'test_helper'

describe Review do
  let(:review) {reviews(:one)}

  describe 'the review is valid' do
    it 'should return false without a rating' do
      review.rating = nil
      review.valid?.must_equal false
    end

    it 'should return false if rating is not between 1 and 5' do
      review.rating = 100
      review.valid?.must_equal false
    end

    it 'should return false if longer than 1000 characters' do
      review.comment = 'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. A small river named Duden flows by their place and supplies it with the necessary regelialia. It is a paradisematic country, in which roasted parts of sentences fly into your mouth. Even the all-powerful Pointing has no control about the blind texts it is an almost unorthographic life One day however a small line of blind text by the name of Lorem Ipsum decided to leave for the far World of Grammar. The Big Oxmox advised her not to do so, because there were thousands of bad Commas, wild Question Marks and devious Semikoli, but the Little Blind Text didn’t listen. She packed her seven versalia, put her initial into the belt and made herself on the way. When she reached the first hills of the Italic Mountains, she had a last view back on the skyline of her hometown Bookmarksgrove, the headline of Alphabet Village and the sub'
      review.valid?.must_equal false
    end
  end

  describe '#product' do
    it 'should return the correct product' do
      review.product.must_equal products(:Skydiving)
    end

    it 'should return the correct number of reviews' do
      products(:Skydiving).reviews.count.must_equal 2
    end
  end
end
