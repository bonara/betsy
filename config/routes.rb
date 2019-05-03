Rails.application.routes.draw do
  root 'products#root'
  resources :products
  resources :merchants, only: %i[index show]
  resources :categories
  resources :orders

  get '/auth/github', as: 'github_login'
  get 'auth/:provider/callback', to: 'merchants#create', as: 'auth_callback'
  delete '/logout', to: 'merchants#destroy', as: 'logout'

  get 'orders/:id' => "orders#show", as: 'show_order'
  delete 'orders/:id' => "orders#destroy"
  post 'orders/:id/checkout' => "orders#checkout", as: 'order_checkout'

end
