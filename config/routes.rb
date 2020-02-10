Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :games 
  resources :pieces


  get 'games/:id/:piece_id/:x_position/:y_position', :to => 'games#show', :as => 'show'
end
