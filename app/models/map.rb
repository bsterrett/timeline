class Map < ActiveRecord::Base
  has_many :troop_spawns
  has_many :tower_spawns
end
