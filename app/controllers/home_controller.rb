class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.available
    @current_user = current_user
  end
end
