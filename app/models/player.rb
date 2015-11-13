class Player < ActiveRecord::Base
  belongs_to :game

  has_many :troops
  has_many :towers
  has_many :bases
  has_many :game_events
  has_many :map_base_spawns
  has_many :map_tower_spawns
  has_many :map_troop_spawns

  def game_pieces
    (troops + towers + bases).flatten
  end

  def living_game_pieces
    (troops.living + towers.living + bases.living).flatten
  end

  def get_next_available_base_spawn
    map_base_spawns.select{ |s| !s.locked? }.sort{ |s1,s2| s1.position <=> s2.position }.first
  end

  def get_next_available_tower_spawn
    map_tower_spawns.select{ |s| !s.locked? }.sort{ |s1,s2| s1.position <=> s2.position }.first
  end

  def get_next_available_troop_spawn
    map_troop_spawns.select{ |s| !s.locked? }.sort{ |s1,s2| s1.position <=> s2.position }.first
  end

  def receive_income resources = current_income
    increment!(:resources, resources)
  end

  def current_income
    50
  end
end
