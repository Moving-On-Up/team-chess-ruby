require 'rails_helper'

RSpec.describe Pawn, type: :model do

  describe "#valid move?" do

# ------ Opening Move ------------

    it "should return true to move one square forward on first move" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:2, y_position: 2, player_id: 1, game_id: game.id, white:false)
      expect(pawn.valid_move?(2, 3)).to eq(true)
    end

    it "should return true to move two squares forward on first move" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:2, y_position: 7, player_id: 1, game_id: game.id, white:true)
      expect(pawn.valid_move?(2, 5)).to eq(true)
    end

    it "should return false to move three squares forward on first move" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:2, y_position: 2, player_id: 1, game_id: game.id, white:false)
      expect(pawn.valid_move?(2, 5)).to eq(false)
    end

    it "should return false to move one square sideways on first move" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:2, y_position: 2, player_id: 1, game_id: game.id, white:false)
      expect(pawn.valid_move?(3, 2)).to eq(false)
    end

# ------ Subsequent Moves ------------

    it "should return true for black pawn to move one square forward" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(pawn.valid_move?(5, 6)).to eq(true)
    end

    it "should return true for white pawn to move one square forward" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:true)
      expect(pawn.valid_move?(5, 4)).to eq(true)
    end

    it "should return false for black pawn to move backward" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:false)
      expect(pawn.valid_move?(5, 4)).to eq(false)
    end

    it "should return false for white pawn to move backward" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:true)
      expect(pawn.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move two squares forward" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:5, y_position: 5, player_id: 1, game_id: game.id, white:true)
      expect(pawn.valid_move?(5, 7)).to eq(false)
    end

    it "should return false to move one square sideways" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:5, y_position: 2, player_id: 1, game_id: game.id, white:true)
      expect(pawn.valid_move?(6, 2)).to eq(false)
    end

    it "should return true if black pawn is moving diagonally to capture opponent piece" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:3, y_position: 3, player_id: 2, game_id: game.id, white:false)
      rook = FactoryBot.create(:pawn, x_position:4, y_position: 4, player_id: 1, game_id: game.id, white:true)
      expect(pawn.valid_move?(4,4)).to eq(true)
    end

    it "should return false if pawn tries to move vertically to square with an opponent piece" do
      current_user = FactoryBot.create(:user, id: 1)
      current_user2 = FactoryBot.create(:user, id: 2)
      game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
      pawn = FactoryBot.create(:pawn, x_position:2, y_position: 6, player_id: 1, game_id: game.id, white:false)
      expect(pawn.valid_move?(2, 7)).to eq(false)
    end

    # ------ En Passant ------------

    #it "should return true for black pawn to capture white pawn en passant" do
    #  current_user = FactoryBot.create(:user, id: 1)
    #  current_user2 = FactoryBot.create(:user, id: 2)
    #  game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    #  black_pawn = FactoryBot.create(:pawn, x_position:2, y_position: 5, player_id: 1, game_id: game.id, white:false)
    #  white_pawn = FactoryBot.create(:pawn, x_position:1, y_position: 5, player_id: 1, game_id: game.id, white:true, move_number: 1)
    #  expect(black_pawn.en_passant?(1, 6)).to eq(true)
    #end

    #it "should return false for black pawn to capture white pawn en passant if not white's first move" do
    #  current_user = FactoryBot.create(:user, id: 1)
    #  current_user2 = FactoryBot.create(:user, id: 2)
    #  game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    #  black_pawn = FactoryBot.create(:pawn, x_position:2, y_position: 5, player_id: 1, game_id: game.id, white:false)
    #  white_pawn = FactoryBot.create(:pawn, x_position:1, y_position: 5, player_id: 1, game_id: game.id, white:true, move_number: 2)
    #  expect(black_pawn.en_passant?(1, 6)).to eq(false)
    #end

    #it "should return false when white pawn is not in a valid position" do
    #  current_user = FactoryBot.create(:user, id: 1)
    #  current_user2 = FactoryBot.create(:user, id: 2)
    #  game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    #  black_pawn = FactoryBot.create(:pawn, x_position:2, y_position: 5, player_id: 1, game_id: game.id, white:false)
    #  white_pawn = FactoryBot.create(:pawn, x_position:4, y_position: 5, player_id: 1, game_id: game.id, white:true, move_number: 1)
    #  expect(black_pawn.en_passant?(1, 6)).to eq(false)
    #end

    #it "should return false for black pawn to capture white rook en passant" do
    #  current_user = FactoryBot.create(:user, id: 1)
    #  current_user2 = FactoryBot.create(:user, id: 2)
    #  game = FactoryBot.create(:game, user_id: 1, turn_player_id: 1, white_player_id: 1, black_player_id: 2)
    #  black_pawn = FactoryBot.create(:pawn, x_position:2, y_position: 5, player_id: 1, game_id: game.id, white:false)
    #  white_rook = FactoryBot.create(:rook, x_position:1, y_position: 5, player_id: 1, game_id: game.id, white:true, move_number: 1)
    #  expect(black_pawn.en_passant?(1, 6)).to eq(false)
    #end
  end
end