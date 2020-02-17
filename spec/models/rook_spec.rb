require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe "#valid move?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
  

    it "should return true to move one square forward" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(rook.valid_move?(6, 5)).to eq(true)
    end

    it "should return true to move one square backward" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(rook.valid_move?(4, 5)).to eq(true)
    end

    it "should return true to move one square up" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(rook.valid_move?(5, 4)).to eq(true)
    end

    it "should return true to move one square down" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(rook.valid_move?(5, 6)).to eq(true)
    end


    it "should return false to move to a non-same-color square" do
      rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(rook.valid_move?(2, 3)).to eq(false)
    end
  end
end 