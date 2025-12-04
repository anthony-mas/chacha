Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :users, only: [:show]

  resources :events do
    # NEW ROUTE FOR DISCOVER PAGE
    collection do
      get :discover
    end
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
