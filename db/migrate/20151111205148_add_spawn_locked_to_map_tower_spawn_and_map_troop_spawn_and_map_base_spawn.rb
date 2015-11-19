class AddSpawnLockedToMapTowerSpawnAndMapTroopSpawnAndMapBaseSpawn < ActiveRecord::Migration
  def change
    add_column :map_base_spawns, :spawn_locked, :boolean, index: true, default: false
    add_column :map_tower_spawns, :spawn_locked, :boolean, index: true, default: false
    add_column :map_troop_spawns, :spawn_locked, :boolean, index: true, default: false
  end
end
