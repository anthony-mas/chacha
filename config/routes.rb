Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  get "/discover", to: "events#discover"

  # Custom route for iCalendar download (generates event_ics_path)
  get 'events/:id/ics', to: 'events#calendar', defaults: { format: :ics }, as: :event_ics

  resources :events do
    resources :participations, only: [:create, :update, :destroy] do
      member do
        patch :update_guest_status
      end
    end
    resources :posts, only: [:create, :destroy]
  end

  resources :posts, only: :show do
    resources :comments, only: [:create]
    resources :reactions, only: [:create, :destroy]
  end

  resources :comments, only: [:destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
