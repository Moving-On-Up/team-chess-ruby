require 'rails_helper'

RSpec.describe PiecesController, type: :controller do

# describe "#contains_own_piece?" do
   # it "should return true if the end coordinates contains own piece" do
    #  game = FactoryBot.create(:game)
     # pawn1 = FactoryBot.create(:pawn, x_position: 5, y_position: 5, white:true, game_id: game.id)
     # pawn2 = FactoryBot.create(:pawn, x_position: 5, y_position: 4, white:true, game_id: game.id)
     # result = pawn1.contains_own_piece?(5,4)
     # expect(result).to eq (true)
    #end
  #end

  describe "is_obstructed?" do

    it "should return true when a piece is obstructed horizontally" do
      game = FactoryBot.create(:game)
      white_rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, white:true, game_id: game.id)
      black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, white:false, game_id: game.id)
      white_queen = FactoryBot.create(:queen, x_position: 4, y_position: 8, white:true, game_id: game.id)
      black_queen = FactoryBot.create(:queen, x_position: 4, y_position: 1, white:false, game_id: game.id)
      expect(white_rook.is_obstructed?(1,6)).to eq true
      expect(black_rook.is_obstructed?(8,3)).to eq true
      expect(white_queen.is_obstructed?(4,6)).to eq true
      expect(black_queen.is_obstructed?())
    end

    it "should return true when a piece is obstructed vertically" do
      game = FactoryBot.create(:game)
      white_rook = FactoryBot.create(:rook, x_position: 1, y_position: 8, white:true, game_id: game.id)
      black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, white:false, game_id: game.id)
      white_queen = FactoryBot.create(:queen, x_position: 4, y_position: 8, white:true, game_id: game.id)
      black_queen = FactoryBot.create(:queen, x_position: 4, y_position: 1, white:false, game_id: game.id)
      expect(white_rook.is_obstructed?(1,6)).to eq true
      expect(black_rook.is_obstructed?(8,3)).to eq true
      expect(white_queen.is_obstructed?(4,6)).to eq true
      expect(black_queen.is_obstructed?())
    end

    it "should return true when a piece is obstructing diagonally" do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 4, white:false, game_id: game.id)
      result = bishop.is_obstructed(5,5)
      expect(result).to eq (true)
    end
  end

  describe "#remove_piece" do
    it "should update captured pieces attributes to nil" do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, game_id: game.id)
      result = bishop.remove_piece(bishop)
      expect(bishop.x_coord).to eq nil
    end
  end
end
