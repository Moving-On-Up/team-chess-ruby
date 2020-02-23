class AddLoserWinnerIdsToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :winner_player_id, :integer
    add_column :games, :loser_player_id, :integer
  end
end
