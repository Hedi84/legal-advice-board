Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :questions, only: %i[index new create show destroy] do
    member do
      patch :close
    end
    resources :answers, only: %i[new create]
  end

  resources :payments, only: %i[update]

  get "up" => "rails/health#show", as: :rails_health_check
end
