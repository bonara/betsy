Rails.application.routes.draw do
  resources :products
  resources :merchants, only: %i[index show]

  get '/auth/github', as: 'github_login'
  get 'auth/:provider/callback', to: 'merchants#create', as: 'auth_callback'
  delete '/logout', to: 'merchants#destroy', as: 'logout'
end
