require 'rails_helper'

RSpec.describe Rook, type: :model do
  
  describe "valid_move?" do
  let(:current_user) { FactoryBot.create(:user, id: 1) }
  let(:current_user2) { FactoryBot.create(:user, id: 2) }
  let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }


  it "should return true to move one square forward" do
    game = FactoryBot.create(:game)
    black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    expect(black_rook.valid_move?(8, 2)).to eq(true)
    expect(black_rook.valid_move?(1, 2)).to eq(true)
  end 

  it "should return true to move two squares forward" do
    game = FactoryBot.create(:game)
    black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    expect(black_rook.valid_move?(8, 3)).to eq(true)
    expect(black_rook.valid_move?(1, 3)).to eq(true)
  end 
    
  it "should return true to move three squares forward" do
    game = FactoryBot.create(:game)
    black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    expect(black_rook.valid_move?(8, 4)).to eq(true)
    expect(black_rook.valid_move?(1, 4)).to eq(true)
  end

    it "should return true to move four squares forward" do
      game = FactoryBot.create(:game)
      black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
      black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
      expect(black_rook.valid_move?(8, 5)).to eq(true)
      expect(black_rook.valid_move?(1, 5)).to eq(true)
    end

  it "should return true to move five squares forward" do
    game = FactoryBot.create(:game)
    black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    expect(black_rook.valid_move?(8, 6)).to eq(true)
    expect(black_rook.valid_move?(1, 6)).to eq(true)
  end

  it "should return true to move six squares forward" do
    game = FactoryBot.create(:game)
    black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    expect(black_rook.valid_move?(8, 7)).to eq(true)
    expect(black_rook.valid_move?(1, 7)).to eq(true)
  end

  it "should return true to move seven squares forward" do
    game = FactoryBot.create(:game)
    black_rook = FactoryBot.create(:rook, x_position: 8, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    black_rook = FactoryBot.create(:rook, x_position: 1, y_position: 1, player_id: current_user2.id, game_id: game.id, white:false)
    expect(black_rook.valid_move?(8, 8)).to eq(true)
    expect(black_rook.valid_move?(1, 8)).to eq(true)
  end

  it "should return true to move one square back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position: 1, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end 

  it "should return true to move two squares back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end 
    
  it "should return true to move three squares back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end

  it "should return true to move four squares back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end

  it "should return true to move five squares back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end

  it "should return true to move six squares back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end

  it "should return true to move seven squares back" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(5, 6)).to eq(false)
  end


  it "should return true to move one square to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end     

  it "should return true to move two squares to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end     

  it "should return true to move three squares to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move four squares to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move five squares to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end     

  it "should return true to move six squares to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move seven squares to the left" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move one square to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end     

  it "should return true to move two squares to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end     

  it "should return true to move three squares to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move four squares to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move five squares to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end     

  it "should return true to move six squares to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end 

  it "should return true to move seven squares to the right" do
    game = FactoryBot.create(:game)
    rook = FactoryBot.create(:rook, x_position:5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
    expect(rook.valid_move?(2, 5)).to eq(false)
  end
end