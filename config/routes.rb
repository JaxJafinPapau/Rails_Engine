Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants#show"
      get "/merchants/find_all", to: "merchants#index"
      get "/items/find", to: "items#show"
      get "/items/find_all", to: "items#index"
      get "/customers/find_all", to: "customers#index"
      get "/customers/find", to: "customers#show"
      get "/transactions/find_all", to: "transactions#index"
      get "/transactions/find", to: "transactions#show"
      get "/invoices/find_all", to: "invoices#index"
      get "/invoices/find", to: "invoices#show"
      get "/invoice_items/find_all", to: "invoice_items#index"
      get "/invoice_items/find", to: "invoice_items#show"
      # get "/merchants/find?name=:name", to: "merchants#show"
      resources :merchants, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :transactions, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
    end
  end

end
