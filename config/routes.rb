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

  get "up" => "rails/health#show", as: :rails_health_check
end
