class ApplicationController < ActionController::Base
  before_action :find_user
  before_action :current_cart

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def find_user
    @login_user = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def current_cart
    if session[:cart_id]
      cart = Cart.find_by(:id => session[:cart_id])
      if cart.present?
        @current_cart = cart
      else
        session[:cart_id] = nil
      end
    end

    if session[:cart_id] == nil
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
  end
end
