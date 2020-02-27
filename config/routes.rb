# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :games do
    patch :forfeit
  end
  resources :pieces



  post 'games/:id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'

end
