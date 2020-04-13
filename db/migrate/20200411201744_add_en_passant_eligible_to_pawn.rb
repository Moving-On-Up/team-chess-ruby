class AddEnPassantEligibleToPawn < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :en_passant_eligible, :integer, default: 0
  end
end
