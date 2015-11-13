class AddBaseCostToTroopTypeAndTowerType < ActiveRecord::Migration
  def change
    add_column :troop_types, :base_cost, :integer, null: false
    add_column :tower_types, :base_cost, :integer, null: false
  end
end
