Rails.application.routes.draw do
  get 'reactions/create'
  get 'reactions/destroy'
  get 'comments/create'
  get 'comments/destroy'
  get 'participations/create'
  get 'participations/destroy'
  devise_for :users
  
  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
