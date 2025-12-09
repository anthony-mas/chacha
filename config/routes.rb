Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  get "/discover", to: "events#discover"

  # ADDED: Custom route for iCalendar download (generates event_ics_path)
  get 'events/:id/ics', to: 'events#calendar', defaults: { format: :ics }, as: :event_ics

  # resources :users, only: [:show] <-- REMOVED

  resources :events do
    resources :participations, only: [:create, :update, :destroy]
    resources :posts, only: [:create, :destroy]
  end

  resources :posts, only: :show do
    resources :comments, only: [:create]
    resources :reactions, only: [:create, :destroy]
  end

  resources :comments, only: [:destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
