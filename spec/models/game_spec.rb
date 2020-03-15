require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:current_user) { FactoryBot.create(:user, id: 1) }
  let(:current_user2) { FactoryBot.create(:user, id: 2) }
  let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
  let(:black_king) { FactoryBot.create(:king, x_position: 5, y_position: 1, player_id: current_user2.id, game_id: game.id, white: false)}
  let(:white_king) { FactoryBot.create(:king, x_position: 5, y_position: 8, player_id: current_user.id, game_id: game.id, white:true)}

  # describe "#contains_piece?" do
  #   it "should return true if the end coordinates contains a piece" do
  #   expect(game.contains_piece?(2, 7)).to eq true
  #   end
  # end

  # describe "#is_in_check" do
  #   it 'should determine that the game is in check' do
  #    game = FactoryBot.create(:game)
  #    king = FactoryBot.create(:king, x_position: 7, y_position: 3, player_id: current_user.id, game_id: game.id, white:false)
  #    king = FactoryBot.create(:king, x_position: 3, y_position: 7, player_id: current_user.id, game_id: game.id, white:true)
  #    bishop = FactoryBot.create(:bishop, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white:true)
  #    expect(game.no_legal_next_move?).to eq true
  #   end
  # end

  # describe "#is_not_in_check" do
  #   it 'should determine that the game is not in check' do
  #    game = FactoryBot.create(:game)
  #    king = FactoryBot.create(:king, x_position: 3, y_position: 3, player_id: current_user.id, game_id: game.id, white:false)
  #    king = FactoryBot.create(:king, x_position: 5, y_position: 3, player_id: current_user.id, game_id: game.id, white:true)
  #    bishop = FactoryBot.create(:bishop, x_position: 4, y_position: 2, player_id: current_user.id, game_id: game.id, white:true)
  #    expect(game.check).to_not eq true
  #   end
  # end

  # describe "#stalemate" do
  #   it 'should detect stalemate' do
  #   # White is in stalemate (returns true) and Black is not (returns false)
  #   black_king = FactoryBot.create(:king, x_position: 1, y_position: 1, player_id: current_user.id, game_id: game.id, white:false)
  #   white_king = FactoryBot.create(:king, x_position: 7, y_position: 0, player_id: current_user.id, game_id: game.id, white:true)
  #   rook = FactoryBot.create(:rook, x_position: 6, y_position: 2, player_id: current_user.id, game_id: game.id, white:false)
  #   rook = FactoryBot.create(:rook, x_position: 4, y_position: 1, player_id: current_user.id, game_id: game.id, white:true)

  #   expect(stalemate(black_king)).to eq true
  #   expect(stalemate(white_king)).to_not eq true
  #   end
  # end

  # describe "#checkmate" do
  #   it 'should detect checkmate' do
  #    game = FactoryBot.create(:game)
  #    expect(game.is_in_checkmate?).to eq true
  #   end
  # end

  # describe "#not_in_checkmate" do
  #   it 'should detect state is not checkmate' do
  #     game = FactoryBot.create(:game)
  #     expect(game.is_in_checkmate?).to_not eq true
  #   end
  # end
end
