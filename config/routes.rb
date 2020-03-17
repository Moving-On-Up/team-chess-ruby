Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :games do
    patch :forfeit
  end
  resources :pieces , only: :update
  resources :users, only: :show

  #post 'pieces/:id/:x_position/:y_position', :to => 'pieces#move', :as => 'move'
  post 'games/:game_id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'
  get 'games/:game_id/promote/:piece_id/:x_position/:y_position', :to => 'games#promote', :as => 'promote'
  post 'games/:game_id/promoted/:piece_id/:x_position/:y_position', :to => 'games#promoted', :as => 'promoted'
end
