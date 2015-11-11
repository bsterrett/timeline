class Map < ActiveRecord::Base
  has_many :map_troop_spawns
  has_many :map_tower_spawns
  has_many :map_base_spawns
end
