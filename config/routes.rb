Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # get '/merchants', to: 'merchants#index'
  # get '/merchants/new', to: 'merchants#new'
  # get '/merchants/:id', to: 'merchants#show'
  # post '/merchants', to: 'merchants#create'
  # get '/merchants/:id/edit', to: 'merchants#edit'
  # patch '/merchants/:id', to: 'merchants#update'
  # delete '/merchants/:id', to: 'merchants#destroy'
  resources :merchants

  # get '/items', to: 'items#index'
  # get '/items/:id', to: 'items#show'
  # get '/items/:id/edit', to: 'items#edit'
  # patch '/items/:id', to: 'items#update'
  resources :items, only: [:index, :show, :edit, :update, :destroy]
  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'
  # delete '/items/:id', to: 'items#destroy'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'
  # get '/reviews/:id/edit', to: 'reviews#edit'
  # patch '/reviews/:id', to: 'reviews#update'
  # delete '/reviews/:id', to: 'reviews#destroy'
  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  patch '/cart/:item_id', to: 'cart#quantity_increments'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  # get '/orders/new', to: 'orders#new'
  # post '/orders', to: 'orders#create'
  # get '/orders/:id', to: 'orders#show'
  resources :orders, only: [:new, :create, :show]

  get '/register/new', to: 'users#new'
  post '/users', to: 'users#create'

  get '/profile', to: 'users#show'

  # sessions
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    # get '/items', to: 'items#index'
    # get '/items/new', to: 'items#new'
    # post '/items', to: 'items#create'
    resources :items, only: [:index, :new, :create]
    patch '/items/:item_id', to: 'items#change_status'
    get '/items/:item_id/edit', to: 'items#edit'
    patch '/items/:item_id/edit', to: 'items#update'
    delete '/items/:item_id', to: 'items#destroy'
    get '/orders/:order_id', to: 'orders#show'
    patch "/orders/:order_id", to: 'orders#update'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'

    patch '/orders/:order_id', to: 'orders#update'

    # get '/merchants', to: 'merchants#index'
    # get '/merchants/:id', to: 'merchants#show'
    # patch '/merchants/:id', to: 'merchants#update'
    resources :merchants, only: [:index, :show, :update]

    get '/users', to: 'users#index'
    get '/users/:user_id', to: 'users#show'
  end

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile/change_password', to: 'users#password_edit'
  patch '/profile/change_password', to: 'users#update_password'
  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:order_id', to: 'user_orders#show'
  patch '/profile/orders/:order_id', to: 'user_orders#update'
end
