require "firebase"

class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :move, :update, :forfeit]

    def new
        @game = Game.new
        
    end

    def index
    end
    
    def create
        @game = current_user.games.create(game_params.merge(white_player_id: current_user.id)
        .merge(current_status: "inactive").merge(current_user: current_user.id))

        white_player_email = User.find_by(id: @game.user_id).email
        firebase_id = @game.name
        data = {
            refresh: false
        }
        
        firebase_url    = 'https://fir-chess-270721.firebaseio.com/';
        firebase_secret = '8g8o1V0UsNy7O1I4kcRXlClM8vo4V4Yi44pQOLqt';
        firebase = Firebase::Client.new(firebase_url, firebase_secret)

        path = "games";
        
        response = firebase.push(path, {
            :name => firebase_id,
            :refresh => false,
            :created => Firebase::ServerValue::TIMESTAMP
          })

        puts "Firebase ID is " + response.body["name"];

        @game.update_attributes(firebase_id: response.body["name"]);

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
        #puts "BEFORE GAME"
        @game = current_game
        #puts "BEFORE PIECES"
        @pieces = current_game.pieces.order(:y_position).order(:x_position).to_a
        #puts "BEFORE KINGS"
        kings = current_game.pieces.where(piece_type: "King") 

        #puts "BEFORE LOOP"

        kings.each do |k| 

            if k.check?
                
                flash.now[:notice] = k.color.capitalize + ' King in Check'
                
            else
                #puts "----- NOT IN CHECK -----"
            end

            # elsif @king.stalemate? 
            #     puts "----- STALEMATE -----"
            #     @king.update_attributes(status: 'Stalemate')
            #     flash.alert 'Stalemate'
            #     # Set game status and result (?)
                
            #     #return
            # end   
        end 

    end
    
    def move
        @game = Game.find_by_id(params[:game_id])
        @pieces = @game.pieces
        @piece = Piece.find_by_id(params[:piece_id])
        @current_user = current_user.id
        if @game.turn_player_id == @current_user
            firebase_url    = 'https://fir-chess-270721.firebaseio.com/';
            firebase_secret = '8g8o1V0UsNy7O1I4kcRXlClM8vo4V4Yi44pQOLqt';
            firebase = Firebase::Client.new(firebase_url, firebase_secret)

            puts "firebase is #{firebase}"

            path = "games/" + @game.firebase_id
    
            @x_position = params[:x_position]
            @y_position = params[:y_position]
            @piece.move_to!(@x_position,@y_position)

            if @piece.piece_type == "Pawn" && @piece.pawn_promotion?
                redirect_to promote_path()
                return
            end

            puts "Before firebase"

            refreshVal = firebase.get(path + "/refresh")

            if refreshVal.body == true
                puts "Firebase set to false"
                response = firebase.update(path, {
                    :refresh => false
                })
            else
                puts "Firebase set to true"
                response = firebase.update(path, {
                    :refresh => true
                  })
            end
            
            else 
                #flash.now[:notice] = "Not yet your turn!"
                puts "nope"
            end
            puts "end"
            #redirect_to game_path(@game)

            respond_to do |format|
                format.js
            end
        end

    def forfeit
        @game = Game.find_by_id(params[:game_id])
        @game.update_attributes(loser_player_id: current_user.id)
        if @game.loser_player_id == @game.white_player_id
            @game.winner_player_id = @game.black_player_id
        else
            @game.winner_player_id = @game.white_player_id
        end
        @game.update_attributes(current_status: "inactive")
        redirect_to root_path
    end

    def promote
        @game = Game.find_by_id(params[:game_id])
        @piece_id = params[:piece_id]
        @white = @game.pieces.find_by(id: @piece_id).white
        @x = params[:x_position]
        @y = params[:y_position]
    end

    def promoted
        @game = Game.find_by_id(params[:game_id])
        @old_id = params[:old_id]
        @new_id = params[:new_id]
        @x = params[:x_position]
        @y = params[:y_position]

        old_piece = @game.pieces.find_by_id(@old_id)
        old_piece.update_attributes(x_position: nil, y_position: nil)

        new_piece = @game.pieces.find_by_id(@new_id)
        new_piece.update_attributes(x_position: @x, y_position: @y, captured: false)

        redirect_to game_path(@game)
    end

    def load_board
        @game = Game.find_by_id(params[:game_id])

        respond_to do |format|
            format.js
        end
    end
   
    def load_display
        @game = Game.find_by_id(params[:game_id])

        respond_to do |format|
            format.js
        end
    end

    private
    
    def game_params
        params.require(:game).permit(:name, :email)
    end

    def current_game
      @game ||= Game.find(params[:id])
    end
end
