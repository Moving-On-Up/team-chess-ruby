Rails.application.routes.draw do

  mount Chat::Engine => "/chat", as: "chat"
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'home#index'
  get "/about", :controller => "home", :action => "about"
  get "/load_active", :controller => "home", :action => "load_active"
  get "/load_available", :controller => "home", :action => "load_available"
  resources :games do
    patch :forfeit
  end
  resources :pieces , only: :update
  resources :users, only: :show

  post 'games/:game_id/:piece_id/:x_position/:y_position', :to => 'games#move', :as => 'move'
  get 'games/:game_id/promote/:piece_id/:x_position/:y_position', :to => 'games#promote', :as => 'promote'
  post 'games/:game_id/promoted/:old_id/:new_id/:x_position/:y_position', :to => 'games#promoted', :as => 'promoted'

  get 'games/:game_id/load_board', :controller => "games", :action => "load_board"
  get 'games/:game_id/load_display', :controller => "games", :action => "load_display"
end
