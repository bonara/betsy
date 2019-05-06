require 'test_helper'

describe MerchantsController do
  describe 'auth_callback' do
    it 'creates an account for a new merchant and redirects to the root route' do
      start_count = Merchant.count
      merchant = Merchant.create(provider: 'github', uid: 99_999, username: 'test_user', name: 'Test User', email: 'test@user.com')

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)

      must_redirect_to root_path

      # Should have created a new user
      Merchant.count.must_equal start_count + 1

      # The new user's ID should be set in the session
      session[:merchant_id].must_equal Merchant.last.id
    end

    it 'logs in an existing merchant and redirects to the root route' do
      start_count = Merchant.count
      merchant = merchants(:grace)

      perform_login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal merchant.id

      # Should *not* have created a new merchant
      Merchant.count.must_equal start_count
    end

    it 'redirects to the login route if given invalid merchant data' do
      start_count = Merchant.count
      merchant = Merchant.new(provider: 'github', uid: -11, username: 'test', name: 'Test User', email: 'test@user.com')

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)

      must_redirect_to root_path

      # Should *not* have created a new user
      Merchant.count.must_equal start_count
    end

    it 'redirects to the login route and deletes the session when merchant logs out' do
      merchant = merchants(:grace)
      perform_login(merchant)
      delete logout_path(merchant)
      must_redirect_to root_path

      session[:merchant_id].must_equal nil
    end
  end
end
