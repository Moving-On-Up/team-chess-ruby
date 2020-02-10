Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :games 
  resources :pieces


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'games/:id/:piece_id/:x_position/:y_position', :to => 'games#show', :as => 'show'
  post 'games/:id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'
end
