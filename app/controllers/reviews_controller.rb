class ReviewsController < ApplicationController

  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = @current_user.id
    @review.product_id = @product.id

    if @review.save
      redirect_to @product
    else
      render 'new'
    end
  end
end

private

def review_params
  params.require(:review).permit(:rating, :comment)
end

