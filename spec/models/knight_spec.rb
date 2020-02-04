require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe "#valid move?" do
    it "should return true to move one square forward, two squares up" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      knight = FactoryBot.create(:knight, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(knight.valid_move?(6, 7)).to eq(true)
    end 

    it "should return true to move one square backward, two squares up" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      knight = FactoryBot.create(:knight, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(knight.valid_move?(4, 7)).to eq(true)
    end 

    it "should return true to move two squares forward, one square down" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      knight = FactoryBot.create(:knight, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(knight.valid_move?(7, 6)).to eq(true)
    end 

    it "should return true to move two squares backward, one square down" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      knight = FactoryBot.create(:knight, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(knight.valid_move?(3, 6)).to eq(true)
    end 

    it "should return false to move two squares horizontal, zero squares vertically" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      knight = FactoryBot.create(:knight, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(knight.valid_move?(7, 5)).to eq(false)
    end 
  end
end