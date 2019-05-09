# frozen_string_literal: true

Rails.application.routes.draw do
  root 'products#root'
  resources :products do
    resources :reviews, only: %i[new create]
  end
  resources :merchants, only: %i[index show]
  resources :categories
  get '/orders/:id/confirmation', to: 'orders#confirmation', as: 'confirmation'
  resources :orders
  resources :order_items

  get 'merchants/:id/dashboard', to: 'merchants#dashboard', as: 'dashboard'
  get '/auth/github', as: 'github_login'
  get 'auth/:provider/callback', to: 'merchants#create', as: 'auth_callback'
  delete '/logout', to: 'merchants#destroy', as: 'logout'

  post '/orders/new', to: 'orders#create'
end
