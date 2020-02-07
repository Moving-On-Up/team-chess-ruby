class AddCapturedToPieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :captured, :boolean, default: false, null: false
    add_column :pieces, :move_number, :integer, default: 0
    add_column :pieces, :king_check, :integer, default: 0
  end
end
