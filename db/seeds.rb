# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

player_action_types = PlayerActionType.create([
  { name: 'build', display_name: 'Build' },
  { name: 'attack', display_name: 'Attack' },
  { name: 'research', display_name: 'Research' },
  { name: 'handshake', display_name: 'Handshake' },
  { name: 'forfeit', display_name: 'Forfeit' }
])

game_statuses = GameStatus.create([
  { name: 'not_started', display_name: 'Not Yet Started' },
  { name: 'in_progress', display_name: 'In Progress' },
  { name: 'finished', display_name: 'Finished' },
  { name: 'error', display_name: 'Error' }
])

troop_types = TroopType.create([
  { name: 'gi', display_name: 'General Infantry', base_attack: 1, base_defense: 0, base_speed: 1 }
])

tower_types = TowerType.create([
  { name: 'arrow_tower', display_name: 'Arrow Tower', base_attack: 1, base_defense: 0, base_speed: 1 }
])

maps = Map.create([
  { name: 'timeline', display_name: 'The Map', max_players: 2, max_player_towers: 3, segment_length: 10 }
])

map_tower_spawns = MapTowerSpawn.create([
  { map_id: 1, location: 1, position: 0 },
  { map_id: 1, location: 3, position: 1 },
  { map_id: 1, location: 5, position: 2 }
])

map_troop_spawns = MapTroopSpawn.create([
  { map_id: 1, location: 9, position: 0 }
])

map_base_spawns = MapBaseSpawn.create([
  { map_id: 1, location: 0, position: 0 }
])

users = User.create([
  { username: 'ben_the_conqueror' },
  { username: 'maverick' },
  { username: 'bane' }
])
