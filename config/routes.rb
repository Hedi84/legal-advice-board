Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :questions, only: %i[index new create show destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
