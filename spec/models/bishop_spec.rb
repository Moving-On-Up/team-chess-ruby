require 'rails_helper'

RSpec.describe Bishop, type: :model do
  
  describe "#valid move?" do

    it "should return true to move diagonally" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(bishop.valid_move?(7, 7)).to eq(true)
    end

    it "should return false to move one square forward" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(bishop.valid_move?(5, 6)).to eq(false)
    end 

    it "should return false to move three squares to the left" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(bishop.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move to a non-same-color square" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      bishop = FactoryBot.create(:bishop, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(bishop.valid_move?(2, 3)).to eq(false)
    end     
  end 

end