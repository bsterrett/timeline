class AddBaseRangeToTowerTypeAndTroopType < ActiveRecord::Migration
  def change
    add_column :tower_types, :base_range, :integer, null: false
    add_column :troop_types, :base_range, :integer, null: false
  end
end
