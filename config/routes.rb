Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  # Ensure the route is at the top level and creates the helper 'discover_path'
  get "/discover", to: "events#discover"

  resources :users, only: [:show]

  resources :events do
    # REMOVE 'collection do get :discover end'
    resources :participations, only: [:create, :destroy]
    resources :posts, only: [:create, :destroy]
  end

  resources :posts, only: :show do
    resources :comments, only: [:create, :destroy]
    resources :reactions, only: [:create, :destroy]
  end

  # Home page
  get "up" => "rails/health#show", as: :rails_health_check
end
