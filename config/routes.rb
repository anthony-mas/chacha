Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  resources :users, only: [:show]

  resources :events do
    resources :participations, only: [:create, :destroy]
    resources :posts, only: [:create, :destroy] do
      resources :comments, only: [:create, :destroy]
      resources :reactions, only: [:create, :destroy]
    end
  end

  # Temporary auto-generated routes (will be cleaned later)
  get "reactions/create"
  get "reactions/destroy"
  get "comments/create"
  get "comments/destroy"
  get "participations/create"
  get "participations/destroy"

  # Chacha page
  get "/chacha", to: "chacha#index"

  # Home page
  get "up" => "rails/health#show", as: :rails_health_check
end
