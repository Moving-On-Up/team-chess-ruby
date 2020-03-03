class AddBlankBoardToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :blank_board, :boolean, default: false, null: false
  end
end
