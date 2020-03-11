class GamesController < ApplicationController
 before_action :authenticate_user!, only: [:new, :create, :show, :move, :update, :forfeit]
  
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
        @game.update_attributes(black_player_id: current_user.id.to_i)     
        @pieces = @game.pieces.where(player_id:nil).update_all(player_id: current_user.id)
        @game.update_attributes(turn_player_id: @game.white_player_id)
        @game.update_attributes(current_status: "active")
        redirect_to game_path(@game)
    end
    
    def show
        @game = current_game
        @pieces = current_game.pieces.order(:y_position).order(:x_position).to_a

        flash.now[:notice] = @game.check.upcase + ' IN CHECK' if @game.check
        flash.now[:notice] = @game.check.upcase + ' IN CHECKMATE' if @game.check && @game.checkmate
    end
    
    def move
        @game = Game.find_by_id(params[:id])
        @pieces = @game.pieces
        #:find_piece
        @piece = Piece.find_by_id(params[:piece_id])
        @current_user = current_user.id
        #:verify_two_players, :verify_player_turn
        if @game.turn_player_id == @current_user
            @x_position = params[:x_position]
            @y_position = params[:y_position]
            #:verify_valid_move
            @piece.move_to!(@x_position,@y_position)
        else 
            flash[:alert] = "Not yet your turn!"
        end
        redirect_to game_path(@game)
    end

    def forfeit
        @game = Game.find_by_id(params[:game_id])
        @game.update_attributes(loser_player_id: current_user.id)
        #@game.update_attributes(winner_player_id: current_user.id)
        if @game.loser_player_id == @game.white_player_id
            @game.winner_player_id = @game.black_player_id
        else
            @game.winner_player_id = @game.white_player_id
        end
        @game.update_attributes(current_status: "inactive")
        redirect_to root_path
    end


    private
    
    def game_params
        params.require(:game).permit(:name)
    end

    def current_game
      @game ||= Game.find(params[:id])
    end
end
