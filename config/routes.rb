Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#login'
      get '/autologin', to: 'sessions#autologin'

      resources :products, only: [:index, :create, :update, :destroy]
      get '/products_by', to: 'products#filter_products'
      
      resources :order_items, only: [:index]
      post '/create-order', to: 'order_items#create'
      patch '/update-order-item/:id', to: 'order_items#update_order_item'
      delete '/delete-order-item/:id', to: 'order_items#delete_order_item'
      post '/place-order', to: 'order_items#place_order'

      resources :users, only: [:index]
      post '/signup', to: 'users#create'
    end
  end
end
