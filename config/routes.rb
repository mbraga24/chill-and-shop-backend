Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#login'
      get '/autologin', to: 'sessions#autologin'

      resources :products, only: [:index, :create, :update, :destroy]
      get '/products_by', to: 'products#filter_products'
      
      resources :order_items, only: [:index, :update]
      post '/create-order', to: 'order_items#create'
      delete '/delete-order-item/:id', to: 'order_items#delete_order_item'

      resources :users, only: [:index]
      post '/signup', to: 'users#create'
    end
  end
end
