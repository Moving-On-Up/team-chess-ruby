class GamesController < ApplicationController
    def index
        @game = Game.order("RANDOM()").first
    end

    def new
        @game = Game.new
    end

    def create
        current_user.games.create(game_params)
        redirect_to root_path
      end
    
    def show
        @game = Game.find(params[:id])
    end
    
    private
    
    def game_params
        params.require(:game).permit(:name)
    end
end
