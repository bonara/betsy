# frozen_string_literal: true

class ReviewsController < ApplicationController
  skip_before_action :require_login
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
      flash[:result_text] = 'Your review was successfully created.'
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
