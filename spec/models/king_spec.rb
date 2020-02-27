# frozen_string_literal: true

require 'rails_helper'

RSpec.describe King, type: :model do
  describe '#valid move?' do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }

    it 'should return true to move one square forward' do
      king = FactoryBot.create(:king, x_position: 5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(king.valid_move?(6, 5)).to eq(true)
    end

    it 'should return true to move one square backward' do
      king = FactoryBot.create(:king, x_position: 5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(king.valid_move?(4, 5)).to eq(true)
    end

    it 'should return true to move one square up' do
      king = FactoryBot.create(:king, x_position: 5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(king.valid_move?(5, 4)).to eq(true)
    end

    it 'should return true to move one square down' do
      king = FactoryBot.create(:king, x_position: 5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(king.valid_move?(5, 6)).to eq(true)
    end

    it 'should return true to move one square diagonally' do
      king = FactoryBot.create(:king, x_position: 5, y_position: 5, player_id: current_user2.id, game_id: game.id, white: false)
      expect(king.valid_move?(6, 6)).to eq(true)
    end

    it 'should return false to move two squares forward' do
      king = FactoryBot.create(:king, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white: true)
      expect(king.valid_move?(7, 5)).to eq(false)
    end
  end

  # describe "#check?" do
  # let(:current_user) { FactoryBot.create(:user, id: 1) }
  # let(:current_user2) { FactoryBot.create(:user, id: 2) }
  # let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }

  # it "should return true for pawn to put king in check" do
  #   king = FactoryBot.create(:king, x_position:3, y_position: 3, player_id: current_user.id, game_id: game.id, white: true)
  #   pawn = FactoryBot.create(:pawn, x_position: 2, y_position: 4, player_id: current_user2.id, game_id: game.id, white: false)
  #   threat = king.check?(king.x_position, king.y_position)
  #   expect(threat.present?).to eq(true)
  # end

  # it "should return false to put king in check" do
  #   king = FactoryBot.create(:king, x_position: 3, y_position: 3, player_id: current_user.id, game_id: game.id, white: true)
  #   rook = FactoryBot.create(:rook, x_position: 7, y_position: 4, player_id: current_user2.id, game_id: game.id, white: false)
  #   threat = king.check?(king.x_position, king.y_position)
  #   expect(threat).to eq(false)
  #  end

  #  it "should return true for rook to put king in check" do
  #   king = FactoryBot.create(:king, x_position: 3, y_position: 3, player_id: current_user.id, game_id: game.id, white: true)
  #   rook = FactoryBot.create(:rook, x_position: 3, y_position: 7, player_id: current_user2.id, game_id: game.id, white: false)
  #   threat = king.check?(king.x_position, king.y_position)
  #   expect(threat.present?).to eq(true)
  #  end
  # end

  # describe "#find_threat_and_determine_checkmate" do
  # let(:current_user) { FactoryBot.create(:user, id: 1) }
  # let(:current_user2) { FactoryBot.create(:user, id: 2) }
  # let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }

  # it "should return true if checkmate is true" do
  #   black_king = game.pieces.find_by(name:"King_black")
  #   black_king.update_attributes(x_position:1, y_position: 4, user_id: 1)
  #   white_pawn = game.pieces.where(name: "Pawn_white")
  #   white_pawn.delete_all
  #   black_pawn = game.pieces.where(name: "Pawn_black")
  #   black_pawn.update_all(user_id: 1)
  #   rook = game.pieces.find_by(name: "Rook_white")
  #   rook.update_attributes(x_position:1, y_position: 8, user_id: 2)
  #   black_pawn1 = FactoryBot.create(:pawn,player_id: 1,x_position:1, y_position: 3, game_id: game.id, white:false)
  #   black_pawn2 = FactoryBot.create(:pawn,player_id: 1,x_position:2, y_position: 3, game_id: game.id, white:false)
  #   black_pawn3 = FactoryBot.create(:pawn,player_id: 1,x_position:2, y_position: 4, game_id: game.id, white:false)
  #   black_pawn4 = FactoryBot.create(:pawn,player_id: 1,x_position:2, y_position: 5, game_id: game.id, white:false)
  #   expect(black_king.find_threat_and_determine_checkmate).to eq true
  # end
  # end

  # describe "#check_mate?" do
  #  let(:current_user) { FactoryBot.create(:user, id: 1) }
  #  let(:current_user2) { FactoryBot.create(:user, id: 2) }
  #  let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
  #
  #  it "should return false if the king has valid_moves left" do
  #     black_king = game.pieces.find_by(name:"King_black")
  #     black_king.update_attributes(x_position:1, y_position: 4, user_id: current_user.id)
  #     white_pawn = game.pieces.where(name: "Pawn_white")
  #     white_pawn.delete_all
  #     black_pawn = game.pieces.where(name: "Pawn_black")
  #     black_pawn.update_all(user_id: current_user.id)
  #     rook = game.pieces.find_by(name: "Rook_white")
  #     rook.update_attributes(x_position:1, y_position: 8, user_id: current_user2.id)
  #     expect(black_king.check_mate?(rook)).to eq false
  #   end

  #   it "should return false if any other piece(knight example) can help block king" do
  #     black_king = game.pieces.find_by(name:"King_black")
  #     black_king.update_attributes(x_position:1, y_position: 4, user_id: current_user.id)
  #     white_pawn = game.pieces.where(name: "Pawn_white")
  #     white_pawn.delete_all
  #     black_pawn = game.pieces.where(name: "Pawn_black")
  #     black_pawn.update_all(user_id: current_user.id)
  #     rook = game.pieces.find_by(name: "Rook_white")
  #     rook.update_attributes(x_position:1, y_position: 8, user_id: current_user2.id)
  #     black_knight = game.pieces.find_by(name:"Knight_black")
  #     black_knight.update_attributes(x_position:2, y_position:5, user_id: current_user.id)
  #     expect(black_king.check_mate?(rook)).to eq false
  #   end

  #   it "should return true if the king has no valid moves, no piece can help block and king cannot capture threat" do
  #     black_king = FactoryBot.create(:king, x_position:1, y_position: 4, player_id: current_user.id, game_id: game.id, white: false, name:"King_black")
  #     rook = FactoryBot.create(:rook, x_position:1, y_position: 8, player_id: current_user2.id, game_id: game.id, white: true, name:"Rook_white")
  #     black_pawn1 = FactoryBot.create(:pawn,player_id: current_user.id,x_position:2, y_position: 2, game_id: game.id, white:false)
  #     black_pawn2 = FactoryBot.create(:pawn,player_id: current_user.id,x_position:2, y_position: 3, game_id: game.id, white:false)
  #     black_pawn3 = FactoryBot.create(:pawn,player_id: current_user.id,x_position:2, y_position: 4, game_id: game.id, white:false)
  #     black_pawn4 = FactoryBot.create(:pawn,player_id: current_user.id,x_position:2, y_position: 5, game_id: game.id, white:false)
  #     expect(black_king.check_mate?(rook)).to eq true
  #   end
  # end
end
