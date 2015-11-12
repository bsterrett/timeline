class AddPlayerToMapTowerSpawnAndMapTroopSpawnAndMapBaseSpawn < ActiveRecord::Migration
  def change
    add_reference :map_base_spawns, :player, index: true, null: false
    add_foreign_key :map_base_spawns, :players

    add_reference :map_tower_spawns, :player, index: true, null: false
    add_foreign_key :map_tower_spawns, :players

    add_reference :map_troop_spawns, :player, index: true, null: false
    add_foreign_key :map_troop_spawns, :players
  end
end
