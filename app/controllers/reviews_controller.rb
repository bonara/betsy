require "test_helper"

describe ReviewsController do
  describe "new" do
    it "returns success when making a new review" do
      get new_product_review_path(Product.first.id)

      must_respond_with :success
    end

    it "returns not found when making a review to product doesn't exists" do
      get new_product_review_path(Product.last.id + 1)
      must_respond_with :not_found
    end
  end

  describe "create" do
    it "redirects to product's page when saving a review" do
      Review.count.must_equal 2
      proc {
        post product_reviews_path(products(:dog).id), params: {
          review: {
            text_review: "This is another review that will be created",
            rating: 2,
            product_id: products(:dog).id
          }
        }
      }.must_change "Review.count", 1

      must_respond_with :redirect
      must_redirect_to product_path(products(:dog).id)
    end

    it "sends bad_request when the review data is bogus" do
      # Arrange
      invalid_review_data = {
        review: {
          #invalid rating, rating should be between 0 and 5
          rating: 15,
          product_id: Product.first.id
        }
      }
      # Double check the data is truly invalid
      Review.new(invalid_review_data[:review]).wont_be :valid?

      start_review_count = Review.count

      # Act
      post product_reviews_path(invalid_review_data[:review][:product_id]), params: invalid_review_data

      # Assert
      must_respond_with :bad_request
      Review.count.must_equal start_review_count
    end

  end

end