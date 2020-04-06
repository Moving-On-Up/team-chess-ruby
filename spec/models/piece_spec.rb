require 'rails_helper'

RSpec.describe Piece, type: :model do

  describe "#contains_own_piece?" do
    it "should return true if the end coordinates contains own piece" do
      game = FactoryBot.create(:game)
      pawn1 = FactoryBot.create(:pawn, x_position: 5, y_position: 5, white:true, game_id: game.id)
      pawn2 = FactoryBot.create(:pawn, x_position: 5, y_position: 4, white:true, game_id: game.id)
      expect(pawn1.contains_own_piece?(5,4)).to eq (true)
    end
  end

  describe "is_obstructed?" do
    let(:game) { FactoryBot.create(:game)}
    let(:white_rook) { FactoryBot.create(:rook, x_position: 1, y_position: 8, white:true, game_id: game.id)}
    let(:white_rook) { FactoryBot.create(:rook, x_position: 8, y_position: 8, white:true, game_id: game.id)}
    let(:black_rook) { FactoryBot.create(:rook, x_position: 1, y_position: 1, white:false, game_id: game.id)}
    let(:black_rook) { FactoryBot.create(:rook, x_position: 8, y_position: 1, white:false, game_id: game.id)}
    let(:white_queen) { FactoryBot.create(:queen, x_position: 4, y_position: 8, white:true, game_id: game.id)}
    let(:black_queen) { FactoryBot.create(:queen, x_position: 4, y_position: 1, white:false, game_id: game.id)}

    it "should return true when a piece is obstructed horizontally" do
      expect(white_rook.is_obstructed?(4,8)).to eq true
      expect(black_rook.is_obstructed?(5,1)).to eq true
      expect(white_queen.is_obstructed?(8,8)).to eq true
      expect(black_queen.is_obstructed?(8,1)).to eq true
    end

    it "should return true when a piece is obstructing diagonally" do
      white_bishop = FactoryBot.create(:bishop, x_position: 2, y_position: 6, white:true, game_id: game.id)
      black_bishop = FactoryBot.create(:bishop, x_position: 6, y_position: 3, white:false, game_id: game.id)
      expect(white_queen.is_obstructed?(2,6)).to eq true
      expect(black_queen.is_obstructed?(6,3)).to eq true
      expect(white_bishop.is_obstructed?(4,8)).to eq true
      expect(black_bishop.is_obstructed?(4,1)).to eq true
    end
  end

  describe "#remove_piece" do
    it "should update captured pieces attributes to nil" do
      game = FactoryBot.create(:game)
      black_pawn = FactoryBot.create(:pawn, x_position: 4, y_position: 2, white:false, game_id: game.id)
      bishop = FactoryBot.create(:bishop, x_position: 3, y_position: 3, white:true, game_id: game.id)
      result = black_pawn.remove_piece(bishop)
      expect(bishop.x_position).to eq nil
    end
  end

  describe "#move_to" do
    let(:current_user) { FactoryBot.create(:user) }
    let(:current_user2) { FactoryBot.create(:user) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    let(:black_king) { FactoryBot.create(:king, x_position: 5, y_position: 1, player_id: current_user2.id, game_id: game.id, white: false)}
    let(:white_king) { FactoryBot.create(:king, x_position: 5, y_position: 8, player_id: current_user.id, game_id: game.id, white:true)}

    it "should update coordinates if successful move" do
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 6, player_id: current_user.id, game_id: game.id, white: true)
      expect(pawn.move_to!(1, 5)).to eq true
      game.reload
      expect(pawn.y_position).to eq 5
    end

    it "should switch player turns if successful move" do
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 6, player_id: current_user.id, game_id: game.id, white: true)
      expect(pawn.move_to!(1, 5)).to eq true
      game.reload
      expect(game.turn_player_id).to eq current_user2.id
    end

    it "should return false and not update coordinates if unsuccessful white pawn move" do
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 7, player_id: current_user.id, game_id: game.id, white: true)
      expect(pawn.move_to!(1, 4)).to eq false
      game.reload
      expect(pawn.y_position).to eq 7
    end

    it "should update coordinates if successful knight move" do
      knight = FactoryBot.create(:knight, x_position: 2, y_position: 8, player_id: current_user.id, game_id: game.id, white: true)
      expect(knight.move_to!(1, 6)).to eq true
      game.reload
      expect(knight.y_position).to eq 6
    end

    it "should return false and not update coordinates if unsuccessful white knight move" do
      knight = FactoryBot.create(:knight, x_position: 2, y_position: 8, player_id: current_user.id, game_id: game.id, white: true)
      expect(knight.move_to!(2, 6)).to eq false
      game.reload
      expect(knight.y_position).to eq 8
    end

     it "should return error if player turn is incorrect" do
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 5, game_id: game.id, white: true)
      pawn.verify_player_turn
      expect(pawn.status).to eq 422
     end

     it "should return error if invalid piece move" do
      pawn = FactoryBot.create(:pawn, x_position: 1, y_position: 6, game_id: game.id, white: true)
      expect(pawn.valid_move?(3, 4, id = nil, white = nil)).to eq false
     end

    it "should return error if the piece is moving to a square occupied by same color" do
      bishop = FactoryBot.create(:bishop, x_position: 1, y_position: 6, game_id: game.id, white: true)
      pawn = FactoryBot.create(:pawn, x_position: 3, y_position: 4, game_id: game.id, white: true)
      expect(bishop.move_to!(3, 4)).to eq false ## true?
    end

    it "should return true if a rook tries to capture opponent" do
      white_rook = FactoryBot.create(:rook, x_position:3, y_position: 3, player_id: current_user.id, game_id: game.id, white:true)
      black_bishop = FactoryBot.create(:bishop, x_position:5, y_position: 3, player_id: current_user2.id, game_id: game.id, white:false)
      expect(white_rook.move_to_capture_piece_and_capture(black_bishop, 5, 3)).to eq true
      game.reload
      expect(black_bishop.x_position).to eq nil
    end

    it "should return false if a pawn tries to capture opponent vertically" do
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_black")
      bishop.update_attributes(x_position: 1, y_position: 6)
      expect(pawn.up?(1, 6) || pawn.down?(1, 6)).to eq true
    end

  end

end
