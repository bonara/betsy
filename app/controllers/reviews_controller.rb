class ReviewsController < ApplicationController
  skip_before_action :require_login
  before_action :find_product, only: [:new]
  before_action :current_user

  def new 
    if @current_user == @product.merchant
      flash[:status] = :failure
      flash[:result_text] = 'You cannot review your own product.'
      redirect_to product_path(@product)
    else
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    if @current_user == @product.merchant
      flash[:status] = :failure
      flash[:result_text] = 'You cannot review your own product.'
      redirect_to product_path(@product)
    else
        @review = @product.reviews.new(
          review_params
        )
      if @review.save
        flash[:status] = :success
        flash[:result_text] = 'Your review was successfully created.'
        redirect_to product_path(@product.id)

      else
        render :new, status: :bad_request
      end
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
