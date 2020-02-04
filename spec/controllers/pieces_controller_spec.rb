require 'rails_helper'

RSpec.describe PiecesController, type: :controller do

  describe "#update" do
    
    it "should update coordinates if successful move" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)    
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position: 5, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, x_position: 5, y_position: 8, player_id: 1, game_id: game.id, white:true)
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 6, player_id: 1, game_id: game.id, white: true)
      post :update, params: {id: pawn.id, piece:{x_position: 1, y_position: 5}}
      expect(response).to have_http_status(200)
      pawn.reload
      expect(pawn.y_position).to eq 5
    end

    it "should switch player turns if successful move" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position:5, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, x_position:5, y_position: 8, player_id: 1, game_id: game.id, white:true)
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 6, player_id: 1, game_id: game.id, white: true)
      post :update, params: {id: pawn.id, piece:{x_position: 1, y_position: 5}}
      expect(response).to have_http_status(200)
      game.reload
      expect(game.turn_player_id).to eq 2
    end

     it "should return error if player turn is incorrect" do
      current_user = FactoryBot.create(:user, id: 1)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create :pawn, x_position: 1, y_position: 6, game_id: game.id, white: true
      post :update, params: {id: pawn.id, piece:{x_position: 1, y_position: 5}}, :format => :json
      expect(response).to have_http_status(422)
     end

     it "should return error if invalid piece move" do
      current_user = FactoryBot.create(:user, id: 1)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create :pawn, x_position: 1, y_position: 6, game_id: game.id, white: true
      post :update, params: {id: pawn.id, piece:{x_position: 3, y_position: 4}}, :format => :json
      expect(response).to have_http_status(422)
     end

     it "should return error if the piece's move path is obstructed" do
      current_user = FactoryBot.create(:user, id: 1)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create :bishop, x_position: 1, y_position: 6, game_id: game.id, white: true
      pawn = FactoryBot.create :pawn, x_position: 2, y_position: 5, game_id: game.id, white: true
      post :update, params: {id: bishop.id, piece:{x_position: 3, y_position: 4}}, :format => :json
      expect(response).to have_http_status(422)
     end

    it "should return error if the piece is moving to a square occupied by same color" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create :bishop, x_position: 1, y_position: 6, game_id: game.id, white: true
      pawn = FactoryBot.create :pawn, x_position: 3, y_position: 4, game_id: game.id, white: true
      post :update, params: {id: bishop.id, piece:{x_position: 3, y_position: 4}}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return true if a rook tries to capture opponent" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position:5, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, x_position:5, y_position: 8, player_id: 1, game_id: game.id, white:true)
      rook = FactoryBot.create(:rook, x_position:3, y_position: 3, player_id: 2, game_id: game.id, white:false)
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 3, player_id: 1, game_id: game.id, white:true)
      post :update, params: {id:rook.id, piece:{x_position: 5, y_position: 3}}
      expect(response).to have_http_status(200)
      bishop.reload
      expect(bishop.x_position).to eq nil
    end

    it "should return false if a pawn tries to capture opponent vertically" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_black")
      bishop.update_attributes(x_position: 1, y_position: 6)
      post :update, params: {id:pawn.id, piece:{x_position: 1, y_position:6}}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return true if a pawn tries to capture opponent diagonally" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position:5, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, x_position:5, y_position: 8, player_id: 1, game_id: game.id, white:true)
      pawn = FactoryBot.create(:pawn, x_position:1, y_position: 7, player_id: 1, game_id: game.id, white:true)
      bishop = FactoryBot.create(:bishop, x_position:2, y_position: 6, player_id: 2, game_id: game.id, white:false)
      post :update, params: {id:pawn.id, piece:{x_position: 2, y_position:6}}
      expect(response).to have_http_status(200)
    end

    it "should return false if a pawn tries to move vertically into a square that contains the same color piece" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_white")
      bishop.update_attributes(x_position: 1, y_position: 6)
      post :update, params: { id: pawn.id, piece:{x_position: 1, y_position:6}}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return status 201 if opponent king is in check and cannot move out of check" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      white_king = FactoryBot.create(:king,player_id: 1,x_position:6, y_position: 2, game_id: game.id, white:true)
      black_king = FactoryBot.create(:king, x_position:1, y_position: 4, player_id: 2, white:false, game_id: game.id)
      rook = FactoryBot.create(:rook, player_id: 1, x_position:1, y_position:8,white:true, game_id: game.id)
      black_piece1 = FactoryBot.create(:pawn,player_id: 2,x_position:1, y_position: 3, game_id: game.id, white:false)
      black_piece2 = FactoryBot.create(:pawn,player_id: 2,x_position:2, y_position: 3, game_id: game.id, white:false)
      black_piece3 = FactoryBot.create(:pawn,player_id: 2,x_position:2, y_position: 4, game_id: game.id, white:false)
      black_piece4 = FactoryBot.create(:pawn,player_id: 2,x_position:2, y_position: 5, game_id: game.id, white:false)
      post :update, params: {id: rook.id, piece: {x_position:1, y_position:7 }}
      expect(response).to have_http_status(201)
    end

    it "should return status 200 if opponent king is in check and can move out of check" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = game.pieces.find_by(name:"King_black")
      black_king.update_attributes(x_position:1, y_position: 4, player_id: 2)
      white_pawn = game.pieces.where(name: "Pawn_white")
      black_pawn = game.pieces.where(name: "Pawn_black")
      black_pawn.update_all(player_id: 2)
      rook = game.pieces.find_by(name: "Rook_white")
      rook.update_attributes(player_id: 1, x_position:1, y_position:8)
      black_piece1 = FactoryBot.create(:pawn,player_id: 2,x_position:1, y_position: 3, game_id: game.id, white:false)
      black_piece2 = FactoryBot.create(:pawn,player_id: 2,x_position:2, y_position: 3, game_id: game.id, white:false)
      black_piece3 = FactoryBot.create(:pawn,player_id: 2,x_position:2, y_position: 4, game_id: game.id, white:false)
      post :update, params: {id: rook.id, piece: {x_position:1, y_position:7 }}
      black_king.reload
      expect(black_king.king_check).to eq 1
      expect(response).to have_http_status(200)
    end

    it "should return status 201 if opponent king is not in check but has no valide moves left (stalemate)" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position:8, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king,player_id: 1,x_position:6, y_position: 2, game_id: game.id, white:true)
      white_queen = FactoryBot.create(:queen,player_id: 1,x_position:7, y_position: 4, game_id: game.id, white:true)
      post :update, params: {id: white_queen.id, piece: {x_position:7, y_position:3 }}
      expect(response).to have_http_status(201)
      game.reload
      expect(game.state).to eq "end"
    end

    it "should return 422 if the king tries to move into check by vertical pawn capture" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position:8, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, player_id: 1, x_position:1, y_position: 6, game_id: game.id, white:true)
      black_pawn = FactoryBot.create(:pawn, x_position: 2, y_position: 4, game_id: game.id, white:false, player_id: 2)
      post :update, params: {id: white_king.id, piece: {x_position:1, y_position:5 }}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return 201 if the queen checks king" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      black_king = FactoryBot.create(:king, x_position:5, y_position: 1, player_id: 2, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, player_id: 1, x_position:5, y_position: 8, game_id: game.id, white:true)
      black_pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 2, game_id: game.id, white:false, player_id: 2)
      black_pawn2 = FactoryBot.create(:pawn, x_position: 5, y_position: 2, game_id: game.id, white:false, player_id: 2)
      black_bishop = FactoryBot.create(:bishop, x_position: 6, y_position: 1, game_id: game.id, white:false, player_id: 2)
      black_queen = FactoryBot.create(:queen, x_position: 4, y_position: 1, game_id: game.id, white:false, player_id: 2)
      white_queen = FactoryBot.create(:queen, player_id: 1, x_position:7, y_position: 3, game_id: game.id, white:true)
      white_bishop = FactoryBot.create(:bishop, player_id: 1, x_position:3, y_position: 5, game_id: game.id, white:true)
      post :update, params: {id: white_queen.id, piece: {x_position:6, y_position:2 }}
      expect(response).to have_http_status(201)
    end

    #it "should update the piece move into the moves model" do
    #  current_user = FactoryBot.create(:user, id: 1)
    #  current_user2 = FactoryBot.create(:user, id: 2)
    #  game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    #  black_king = FactoryBot.create(:king, x_position:5, y_position: 1, player_id: 2, game_id: game.id, white: false)
    #  white_king = FactoryBot.create(:king, player_id: 1, x_position:5, y_position: 8, game_id: game.id, white:true)
    #  black_pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 2, game_id: game.id, white:false, player_id: 2)
    #  post :update, params: {id: black_pawn.id, piece: {x_position:4, y_position:3 }}
    #  expect(game.moves.last.x_position).to eq 4
    #  expect(game.moves.last.piece_type).to eq "Pawn"
    #end
  end
end
