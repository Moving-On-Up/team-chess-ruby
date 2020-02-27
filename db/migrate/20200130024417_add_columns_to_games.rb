# frozen_string_literal: true

class AddColumnsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :white_player_id, :integer
    add_column :games, :black_player_id, :integer
    add_column :games, :current_status, :string
    add_column :games, :current_user, :string
  end
end
