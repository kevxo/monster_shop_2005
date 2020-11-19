Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  patch '/cart/:item_id', to: 'cart#quantity_increments'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  resources :orders, only: [:new, :create, :show]

  get '/register/new', to: 'users#new'
  resources :users, only: [:create]

  get '/profile', to: 'users#show'

  # sessions
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index'
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
    resources :merchants, only: [:index, :show, :update]
    resources :users, only: [:index]
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
