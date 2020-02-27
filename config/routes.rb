# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :games do
    patch :forfeit
  end
  resources :pieces

<<<<<<< HEAD
  get 'games/:id/:piece_id/:x_position/:y_position', to: 'games#show', as: 'show'
=======

  post 'games/:id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'
>>>>>>> c6b7240cdc1b5eef4d583ca346c029cead1eabcf
end
