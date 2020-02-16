require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe "#valid move?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
  
    it 'should return true to move forward' do
      @rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(@rook.valid_move?(5,6)).to eq true
    end

    it 'should return true to move horizontal' do
      @rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(@rook.valid_move?(5,6)).to eq true
    end
 
    it 'should return false to move diagonal' do
      @rook = FactoryBot.create(:rook, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white:false)
      expect(@rook.valid_move?(6,6)).to eq false
    end
  end
end 