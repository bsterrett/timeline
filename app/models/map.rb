class Map < ActiveRecord::Base
  has_many :map_troop_spawns
  has_many :map_tower_spawns
  has_many :map_base_spawns

  def map_fixtures
    [map_troop_spawns + map_tower_spawns + map_base_spawns].flatten
  end
  alias_method :fixtures, :map_fixtures
end
