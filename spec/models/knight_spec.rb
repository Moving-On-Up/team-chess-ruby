
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe '#valid move?' do
    let(:current_user) { FactoryBot.create(:user, id: 1) }
    let(:current_user2) { FactoryBot.create(:user, id: 2) }
    let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }

    it 'should return true to move one square forward, two squares up' do
      knight = FactoryBot.create(:knight, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white: false)
      expect(knight.valid_move?(6, 7)).to eq(true)
    end

    it 'should return true to move one square backward, two squares up' do
      knight = FactoryBot.create(:knight, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white: false)
      expect(knight.valid_move?(4, 7)).to eq(true)
    end

    it 'should return true to move two squares forward, one square down' do
      knight = FactoryBot.create(:knight, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white: false)
      expect(knight.valid_move?(7, 6)).to eq(true)
    end

    it 'should return true to move two squares backward, one square down' do
      knight = FactoryBot.create(:knight, x_position: 5, y_position: 5, player_id: current_user.id, game_id: game.id, white: false)
      expect(knight.valid_move?(3, 6)).to eq(true)
    end
  end
end

