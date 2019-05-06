class MerchantsController < ApplicationController
  before_action :require_login, only: %i[destroy dashboard]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if @merchant
      # User was found in the database
      flash[:status] = :success
      flash[:result_text] = "Logged in as returning user #{@merchant.name}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      @merchant = Merchant.build_from_github(auth_hash)

      if @merchant.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{@merchant.name}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        binding.pry
        flash.now[:status] = :failure
        flash.now[:result_text] = '"Could not create new user account:'
        flash.now[:messages] = @merchant.errors.messages
        return redirect_to root_path
      end
    end

    binding.pry

    # If we get here, we have a valid user instance
    session[:merchant_id] = @merchant.id
    redirect_to root_path
  end

  def destroy
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out!"
    redirect_to root_path
  end

  def dashboard
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end
end
