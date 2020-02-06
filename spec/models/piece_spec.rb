require 'rails_helper'

RSpec.describe Piece, type: :model do
  
  describe "#contains_own_piece?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    it "should return true if the end coordinates contains own piece" do
      pawn1 = FactoryBot.create(:pawn, x_position: 5, y_position: 5, player_id: current_user.id, white:true, game_id: game.id)
      pawn2 = FactoryBot.create(:pawn, x_position: 5, y_position: 4, player_id: current_user2.id, white:true, game_id: game.id)
      result = pawn1.contains_own_piece?(5,4)
      expect(result).to eq (true)
    end
  end

  describe "#is_obstructed" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    it "should return true if there is a piece obstructing horizontal path" do
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 6, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
      result = rook.is_obstructed(7,5)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing vertical path" do
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 5, y_position: 6, white:true, player_id: current_user.id, game_id: game.id)
      result = rook.is_obstructed(5,7)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing diagonal path" do
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, player_id: current_user.id, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 4, white:false, player_id: current_user.id, game_id: game.id)
      result = bishop.is_obstructed(5,5)
      expect(result).to eq (true)
    end
  end

  describe "#remove_piece" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    it "should update captured pieces attributes to nil" do
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, player_id: current_user.id, white:true, game_id: game.id)
      result = bishop.remove_piece(bishop)
      expect(bishop.x_position).to eq nil
    end
  end
end
