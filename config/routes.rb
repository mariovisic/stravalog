Rails.application.routes.draw do
  root 'activities#index'

  get '/auth/strava/callback' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'map', to: 'maps#index'

  namespace :admin do
    root 'dashboard#index'
    resources :activities, only: [ :new, :create, :edit, :update ]
  end

  get ':id', to: 'activities#show', as: :activity
end
