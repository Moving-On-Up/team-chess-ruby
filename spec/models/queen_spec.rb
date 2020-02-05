require 'rails_helper'

RSpec.describe Queen, type: :model do
  let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }

  it "should return true to move diagonally" do
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(queen.valid_move?(7, 7)).to eq(true)
  end

  it "should return true to move three squares backward" do
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(queen.valid_move?(5, 2)).to eq(true)
  end

  it "should return true to move two squares to the right" do
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(queen.valid_move?(7, 5)).to eq(true)
  end

  it "should return false to move one square forward, two squares up" do
    queen = FactoryBot.create(:queen, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(queen.valid_move?(6, 7)).to eq(false)
  end   

end