class ProductsController < ApplicationController
  def root; end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end

  def new
    @product =  Product.new
  end

  def create
    product = Product.new(product_params)
  
    successful = product.save
    if successful
      flash[:status] = :success
      flash[:message] = "successfully saved created #{product.name}"
      redirect_to products_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save category"
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
    return params.require(:product).permit(:name, :description, :stock, :price, :photo_url)
  end
end
