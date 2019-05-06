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
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoices, only: [:index]
      end
      resources :items, only: [:index, :show] do
        get "/invoice_items", to: "invoice_items#index"
        get "/merchant", to: "merchants#show"
      end
      resources :customers, only: [:index, :show] do
        get "/invoices", to: "invoices#index"
        get "/transactions", to: "transactions#index"
      end
      resources :transactions, only: [:index, :show] do
        get "/invoice", to: "invoices#show"
      end
      resources :invoices, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoice_items, only: [:index]
        resources :transactions, only: [:index]
        get "/merchant", to: "merchants#show"
        get "/customer", to: "customers#show"
      end
      resources :invoice_items, only: [:index, :show] do
        get "/invoice", to: "invoices#show"
      end
    end
  end

end
