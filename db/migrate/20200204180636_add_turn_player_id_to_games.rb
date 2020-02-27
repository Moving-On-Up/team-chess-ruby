# frozen_string_literal: true

class AddTurnPlayerIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :turn_player_id, :integer
  end
end
