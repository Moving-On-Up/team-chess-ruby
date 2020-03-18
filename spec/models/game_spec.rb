require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:current_user) { FactoryBot.create(:user, id: 1) }
  let(:current_user2) { FactoryBot.create(:user, id: 2) }
  let(:game) { FactoryBot.create(:game, user_id: current_user.id, turn_player_id: current_user.id, white_player_id: current_user.id, black_player_id: current_user2.id) }
  let(:black_king) { FactoryBot.create(:king, x_position: 5, y_position: 1, player_id: current_user2.id, game_id: game.id, white: false)}
  let(:white_king) { FactoryBot.create(:king, x_position: 5, y_position: 8, player_id: current_user.id, game_id: game.id, white:true)}

  describe "#contains_piece?" do
    it "should return true if the end coordinates contains a piece" do
    expect(game.contains_piece?(2, 7)).to eq true
    end
  end


end
