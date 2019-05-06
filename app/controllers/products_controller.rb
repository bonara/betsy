class ProductsController < ApplicationController
  skip_before_action :require_login, except: %i[new create destroy]
  def root; end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params.merge({ merchant_id: session[:merchant_id] }))

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created product with ID #{@product.id}"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash[:result_text] = 'Could not create a product'
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def destroy
    @product.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully destroyed #{product.name}"
    redirect_to products_path
  end

  def product_params
    params.require(:product).permit(:name, :description, :stock, :price, :photo_url)
  end
end
