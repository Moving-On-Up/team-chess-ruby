require 'rails_helper'

RSpec.describe Game, type: :model do

    describe "#is_check?" do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
    
    it "should return true if there is a check condition" do
      rook = FactoryBot.create(:rook, x_position: 4, y_position: 4, white:true, player_id: current_user.id, game_id: game.id)
      king = FactoryBot.create(:king, x_position: 6, y_position: 4, white:false, player_id: current_user2.id, game_id: game.id)
      result = game.is_check?()
      expect(result).to eq (true)
    end

    it "should return false if there is no check condition" do
        rook = FactoryBot.create(:rook, x_position: 4, y_position: 4, white:true, player_id: current_user.id, game_id: game.id)
        king = FactoryBot.create(:king, x_position: 5, y_position: 5, white:false, player_id: current_user2.id, game_id: game.id)
        result = game.is_check?()
        expect(result).to eq (false)
      end

    it "should return false after initial board creation" do
        result = game.is_check?()
        expect(result).to eq (false)
      end

    end
end

