Rails.application.routes.draw do
  root 'activities#index'
  resources :activities, only: [ :show ]

  get '/auth/strava/callback' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
end
