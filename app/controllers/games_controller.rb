class GamesController < ApplicationController
 before_action :authenticate_user!, only: [:new, :create, :show, :update]
  
    def new
        @game = Game.new
    end

    def create
        current_user.games.create(game_params.merge(white_player_id: current_user.id)
            .merge(current_status: "inactive").merge(current_user: current_user.id))
        redirect_to root_path
    end


    def update
        @game = Game.find_by_id(params[:id])
        @game.update_attributes(black_player_id: current_user.id)
        @game.update_attributes(current_status: "active")
        redirect_to game_path(@game)
    end
    
    def show
        @game = Game.find_by_id(params[:id])
    end
    
    def move
        @game = Game.find(params[:id])
        @pieces = @game.pieces
        @piece = Piece.find(params[:piece_type])
        @piece_type = params[:piece_type]
        @x_position = params[:x_position]
        @y_position = params[:y_position]
        @piece.update_attributes({:x_position => @x_position, :y_position => @y_position})
        redirect_to game_path(@game)
    end


    private
    
    def game_params
        params.require(:game).permit(:name)
    end
end
