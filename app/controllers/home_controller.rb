class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
    @current_user = current_user
  end

  def about
  end
  
end
