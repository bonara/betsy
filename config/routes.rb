# frozen_string_literal: true

Rails.application.routes.draw do
  root 'products#root'
  resources :products
  resources :merchants, only: %i[index show]
  resources :categories
  resources :orders
  resources :order_items


  get 'merchants/:id/dashboard', to: 'merchants#dashboard', as: 'dashboard'
  get '/auth/github', as: 'github_login'
  get 'auth/:provider/callback', to: 'merchants#create', as: 'auth_callback'
  delete '/logout', to: 'merchants#destroy', as: 'logout'

  post 'order_items/:id/add', to: 'order_items#add_quantity', as: "order_item_add"
  post 'order_items/:id/reduce', to: 'order_items#reduce_quantity', as: "order_item_reduce"
  delete 'order_items/:id', to: 'order_items#destroy', as: 'order_item_delete'

  get '/shoppingcart', to: 'orders#show', as: 'show_cart'

end
