Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#login'
      get '/autologin', to: 'sessions#autologin'

      resources :products, only: [:index, :create, :update, :destroy]
      get '/products_by', to: 'products#filter_products'
      
      resources :order_items, only: [:create, :update, :destroy]

      resources :users, only: [:index]
      post '/signup', to: 'users#create'
    end
  end
end
