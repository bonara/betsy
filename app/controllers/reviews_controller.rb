# frozen_string_literal: true

class ReviewsController < ApplicationController
  # Added methods for if session id present or session id nil
  # note: can leave a review if signed in or not signed in
  # note: signed in user cannot review their own product(s)
  before_action :find_product, only: [:new]

  def new
    if session[:user_id] == @product.user_id
      flash[:message] = 'You cannot review your own product.'
      redirect_to products_path
      nil
    else
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = @product.reviews.new(
      review_params
    )
    if @review.save
      flash[:result_text] = 'Your review was created.'
      redirect_to product_path(@product.id)

    else
      render :new, status: :bad_request
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:product_id])
    head :not_found unless @product
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :product_id)
  end
end
