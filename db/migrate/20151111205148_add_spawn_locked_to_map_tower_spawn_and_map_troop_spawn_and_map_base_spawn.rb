class AddSpawnLockedToMapTowerSpawnAndMapTroopSpawnAndMapBaseSpawn < ActiveRecord::Migration
  def change
    add_column :map_base_spawns, :spawn_locked, :boolean, index: true, default: 0
    add_column :map_tower_spawns, :spawn_locked, :boolean, index: true, default: 0
    add_column :map_troop_spawns, :spawn_locked, :boolean, index: true, default: 0
  end
end
