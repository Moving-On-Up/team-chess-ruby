Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :games do
    patch :forfeit
  end
  resources :pieces , only: :update

  #post 'pieces/:id/:x_position/:y_position', :to => 'pieces#move', :as => 'move'
  post 'games/:id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'
end
