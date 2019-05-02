Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants#show"
      get "/merchants/find_all", to: "merchants#index"
      get "/items/find", to: "items#show"
      # get "/merchants/find?name=:name", to: "merchants#show"
      resources :merchants, only: [:index, :show] do
      end
      resources :items, only: [:index, :show]
    end
  end

end
