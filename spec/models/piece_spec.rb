require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe "#contains_own_piece?" do
    it "should return true if the end coordinates contains own piece" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn1 = FactoryBot.create(:pawn, x_position: 5, y_position: 5, player_id: 1, white:true, game_id: game.id)
      pawn2 = FactoryBot.create(:pawn, x_position: 5, y_position: 4, player_id: 2, white:true, game_id: game.id)
      result = pawn1.contains_own_piece?(5,4)
      expect(result).to eq (true)
    end
  end

  describe "#is_obstructed" do
    it "should return true if there is a piece obstructing horizontal path" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: 1, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 6, y_position: 5, white:true, player_id: 1, game_id: game.id)
      result = rook.is_obstructed(7,5)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing vertical path" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: 1, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 5, y_position: 6, white:true, player_id: 1, game_id: game.id)
      result = rook.is_obstructed(5,7)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing diagonal path" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, player_id: 1, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 4, white:false, player_id: 1, game_id: game.id)
      result = bishop.is_obstructed(5,5)
      expect(result).to eq (true)
    end
  end

  describe "#remove_piece" do
    it "should update captured pieces attributes to nil" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, player_id: 1, white:true, game_id: game.id)
      result = bishop.remove_piece(bishop)
      expect(bishop.x_position).to eq nil
    end
  end

end
