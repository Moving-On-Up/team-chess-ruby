class AddStatusToPieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :status, :integer, default: 0
  end
end
