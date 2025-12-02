Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users

  # Main landing page (Mahé)
  root "pages#home"
  get "/home", to: "pages#home"

  # User profile page (Charlotte)
  resources :users, only: [:show]

  # 🔹 Your part: Events resource (host + guest)
  resources :events

  # Temporary auto-generated routes (will be cleaned later)
  get "reactions/create"
  get "reactions/destroy"
  get "comments/create"
  get "comments/destroy"
  get "participations/create"
  get "participations/destroy"

  # Home page
  root "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check
end
