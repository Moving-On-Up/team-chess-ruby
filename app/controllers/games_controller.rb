class GamesController < ApplicationController
 before_action :authenticate_user!, only: [:new, :create, :show, :update]
    def new
        @game = Game.new
    end

    def create
        current_user.games.create(game_params.merge(white_player_id: current_user.id)
            .merge(current_status: "inactive"))
        redirect_to root_path
    end

    def update
        @game = Game.find_by_id(params[:id])
        @game.update_attributes(black_player_id: current_user.id)
        redirect_to game_path(@game)
    end
    
    def show
        @game = Game.find_by_id(params[:id])
    end
    
    private
    
    def game_params
        params.require(:game).permit(:name)
    end
end
