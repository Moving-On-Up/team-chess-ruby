Rails.application.routes.draw do
  mount Chat::Engine => "/chat", as: "chat"
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'home#index'
  get "/about", :controller => "home", :action => "about"
  resources :games do
    patch :forfeit
  end
  resources :pieces , only: :update
  resources :users, only: :show

  post 'games/:game_id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'
  get 'games/:game_id/promote/:piece_id/:x_position/:y_position', :to => 'games#promote', :as => 'promote'
  post 'games/:game_id/promoted/:old_id/:new_id/:x_position/:y_position', :to => 'games#promoted', :as => 'promoted'

end
