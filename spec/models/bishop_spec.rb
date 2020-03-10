require 'rails_helper'

RSpec.describe Bishop, type: :model do
  
  describe "#valid move?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }

    it "should return true to move diagonally" do
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(bishop.valid_move?(7, 7, id = nil, white = nil)).to eq(true)
    end

    it "should return false to move one square forward" do
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(bishop.valid_move?(5, 6, id = nil, white = nil)).to eq(false)
    end 

    it "should return false to move three squares to the left" do
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(bishop.valid_move?(2, 5, id = nil, white = nil)).to eq(false)
    end     

    it "should return false to move to a non-same-color square" do
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(bishop.valid_move?(2, 3, id = nil, white = nil)).to eq(false)
    end     
  end 

end