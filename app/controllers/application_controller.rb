class ApplicationController < ActionController::Base
  before_action :find_user

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError, 'Not Found'
  end
      
  before_action :current_cart

  private

  def find_user
    @login_user = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def current_cart
    # If a session[:cart_id] already exists then find the Cart with that id, 
    # If there is no cart with that id then set the session id to nil.
    if session[:cart_id]
      cart = Cart.find_by(:id => session[:cart_id])
      if cart.present?
        @current_cart = cart
      else
        session[:cart_id] = nil
      end
    end

    # If there is no session[:cart_id] associated with this user 
    # then create a new cart and store it in the users session id
    if session[:cart_id] == nil
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
  end
end
