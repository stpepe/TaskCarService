Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :categories
  #resources :orders
  get "/orders", to: "orders#index", as: "orders"
  post "/orders", to: "orders#index", as: "sort_orders"
  get "/orders/new", to: "orders#new", as: "new_order"
  post "/orders/new", to: "orders#create", as: "create_order"
  get "/orders/edit/:id", to: "orders#edit", as: "edit_order"
  patch "/orders/edit/:id", to: "orders#update", as: "update_order"
  post "/orders/:id", to: "orders#destroy", as: "destroy_order"
  
  resources :executors
  resources :services
  root "orders#index"
end
