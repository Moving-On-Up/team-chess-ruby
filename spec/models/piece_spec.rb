require 'rails_helper'

RSpec.describe Piece, type: :model do
  
  describe "#contains_own_piece?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    it "should return true if the end coordinates contains own piece" do
<<<<<<< HEAD
      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
=======

      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
      pawn1 = FactoryBot.create(:pawn, x_position: 5, y_position: 5, white:true, game_id: game.id)
      pawn2 = FactoryBot.create(:pawn, x_position: 5, y_position: 4, white:true, game_id: game.id)
>>>>>>> a6396816c798e4955980840ebdc59aca2528a829
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
<<<<<<< HEAD

      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 6, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)

=======
      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 6, y_position: 5, white:true, game_id: game.id)
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 6, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
>>>>>>> a6396816c798e4955980840ebdc59aca2528a829
      result = rook.is_obstructed(7,5)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing vertical path" do
<<<<<<< HEAD

      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
=======
      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 5, y_position: 6, white:true, game_id: game.id)
>>>>>>> a6396816c798e4955980840ebdc59aca2528a829
      rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, white:true, player_id: current_user.id, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 5, y_position: 6, white:true, player_id: current_user.id, game_id: game.id)
      result = rook.is_obstructed(5,7)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing diagonal path" do
      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
<<<<<<< HEAD
=======
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, game_id: game.id)
      pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 4, white:false, game_id: game.id)
>>>>>>> a6396816c798e4955980840ebdc59aca2528a829
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
      active_user = FactoryBot.create(:user)
      game = FactoryBot.create(:game, user: active_user)
<<<<<<< HEAD
=======
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, game_id: game.id)
>>>>>>> a6396816c798e4955980840ebdc59aca2528a829
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, player_id: current_user.id, white:true, game_id: game.id)
      result = bishop.remove_piece(bishop)
      expect(bishop.x_position).to eq nil
    end
  end
end
