Rails.application.routes.draw do
  devise_for :users

  # Home page
  root "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check
end
