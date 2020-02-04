require 'rails_helper'

RSpec.describe Queen, type: :model do

  it "should return true to move diagonally" do
    current_user = FactoryBot.create(:user, id: 1)
    current_user2 = FactoryBot.create(:user, id: 2)
    game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
    expect(queen.valid_move?(7, 7)).to eq(true)
  end

  it "should return true to move three squares backward" do
    current_user = FactoryBot.create(:user, id: 1)
    current_user2 = FactoryBot.create(:user, id: 2)
    game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(queen.valid_move?(5, 2)).to eq(true)
  end

  it "should return true to move two squares to the right" do
    current_user = FactoryBot.create(:user, id: 1)
    current_user2 = FactoryBot.create(:user, id: 2)
    game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
    expect(queen.valid_move?(7, 5)).to eq(true)
  end

  it "should return false to move one square forward, two squares up" do
    current_user = FactoryBot.create(:user, id: 1)
    current_user2 = FactoryBot.create(:user, id: 2)
    game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
    expect(queen.valid_move?(6, 7)).to eq(false)
  end   

end