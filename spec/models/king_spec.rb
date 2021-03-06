require 'rails_helper'

RSpec.describe King, type: :model do

  describe "#valid move?" do
   let(:current_user) { FactoryBot.create(:user, id: 1) }
   let(:current_user2) { FactoryBot.create(:user, id: 2) }
   let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
   let(:king) { FactoryBot.create(:king, x_position:5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false) }

   it "should return true to move one square forward" do
    expect(king.valid_move?(6, 5)).to eq(true)
   end

   it "should return true to move one square backward" do
    expect(king.valid_move?(4, 5)).to eq(true)
   end

   it "should return true to move one square up" do
    expect(king.valid_move?(5, 4)).to eq(true)
   end

   it "should return true to move one square down" do
    expect(king.valid_move?(5, 6)).to eq(true)
   end

   it "should return true to move one square diagonally" do
    expect(king.valid_move?(6, 6)).to eq(true)
   end

   it "should return false to move two squares forward" do
    expect(king.valid_move?(7, 5)).to eq(false)
   end

  end

  describe "#check?" do
   let(:current_user) { FactoryBot.create(:user, id: 1) }
   let(:current_user2) { FactoryBot.create(:user, id: 2) }
   let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
   let(:king) { FactoryBot.create(:king, x_position: 3, y_position: 3, player_id: current_user.id, game_id: game.id, white: true) }
  
    it 'should return true when king is in check' do
        rook = FactoryBot.create(:rook, x_position: 1, y_position: 3, white: false, game: game)
        expect(king.check?).to be true
    end
  end

  describe "#find_threat_and_determine_checkmate" do
   let(:current_user) { FactoryBot.create(:user, id: 1) }
   let(:current_user2) { FactoryBot.create(:user, id: 2) }
   let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
   let(:black_king) { FactoryBot.create(:king, x_position: 1, y_position: 4, player_id: current_user2.id, game_id: game.id, white: false) }

    it "should return false if opponent king is in check and cannot move out of check" do
      rook = FactoryBot.create(:rook, player_id: current_user.id, x_position:1, y_position:8,white:true, game_id: game.id)
      black_piece1 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:1, y_position: 3, game_id: game.id, white:false)
      black_piece2 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 3, game_id: game.id, white:false)
      black_piece3 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 4, game_id: game.id, white:false)
      black_piece4 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 5, game_id: game.id, white:false) 
      expect(black_king.checkmate?).to eq false
    end
    
    it "should return true if opponent king is in check and can move out of check" do
      rook = FactoryBot.create(:rook, x_position:1, y_position:8, game: game, white: true)
      black_piece1 = FactoryBot.create(:pawn, x_position:1, y_position: 3, game: game, white:false)
      black_piece2 = FactoryBot.create(:pawn, x_position:2, y_position: 3, game: game, white:false)
      black_piece3 = FactoryBot.create(:pawn, x_position:2, y_position: 4, game: game, white:false)
      expect(rook.move_to!(1, 7)).to eq false
      game.reload
      expect(black_king.check?).to eq true
    end


    it "should return status 201 if opponent king is not in check but has no valid moves left (stalemate)" do
      black_king = FactoryBot.create(:king, x_position:8, y_position: 1, player_id: current_user2.id, game_id: game.id, white: false)
      white_king = FactoryBot.create(:king, player_id: current_user.id,x_position:6, y_position: 2, game_id: game.id, white:true)
      white_queen = FactoryBot.create(:queen, player_id: current_user.id,x_position:7, y_position: 4, game_id: game.id, white:true)
      expect(white_queen.move_to!(7, 3)).to eq true
      game.reload
    end
     
    it "should return false if the king tries to move into check by vertical pawn capture" do
      black_king = FactoryBot.create(:king, x_position:8, y_position: 1, game: game, white: false)
      white_king = FactoryBot.create(:king, x_position:1, y_position: 6, game: game, white:true)
      black_pawn = FactoryBot.create(:pawn, x_position: 2, y_position: 4, game: game, white:false)
      expect(white_king.move_to!(1, 5)).to eq false
    end

  end

  describe "#check_mate?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    let(:black_king) { FactoryBot.create(:king, x_position:1, y_position: 4, player_id: current_user2.id, game_id: game.id, white: false, name:"King_black") }

    it "should return false if the king has valid_moves left" do
       white_pawn = game.pieces.where(name: "Pawn_white")
       white_pawn.delete_all
       white_rook = game.pieces.find_by(name: "Rook_white")
       white_rook.update_attributes(x_position:1, y_position: 8, player_id: current_user.id)
       expect(black_king.checkmate?).to eq false
     end

     it "should return false if any other piece(knight example) can help block king" do
       white_pawn = game.pieces.where(name: "Pawn_white")
       white_pawn.delete_all
       white_rook = game.pieces.find_by(name: "Rook_white")
       white_rook.update_attributes(x_position:1, y_position: 8, player_id: current_user.id)
       black_knight = game.pieces.find_by(name:"Knight_black")
       black_knight.update_attributes(x_position:2, y_position:6, player_id: current_user2.id)
       expect(black_king.checkmate?).to eq false
     end
     
     it "should return true if the king has no valid moves, no piece can help block and king cannot capture threat" do
      white_rook = FactoryBot.create(:rook, x_position:1, y_position: 8, player_id: current_user.id, game_id: game.id, white: true, name:"Rook_white")
      black_pawn1 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 2, game_id: game.id, white:false)
      black_pawn2 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 3, game_id: game.id, white:false)
      black_pawn3 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 4, game_id: game.id, white:false)
      black_pawn4 = FactoryBot.create(:pawn, player_id: current_user2.id,x_position:2, y_position: 5, game_id: game.id, white:false)
      expect(black_king.no_legal_next_move?).to eq true
     end
  end
end

