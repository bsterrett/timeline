# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Starting db:seed, this could be a while..."

player_action_types = PlayerActionType.create([
  { name: 'build_troop', display_name: 'Build A Soldier' },
  { name: 'build_tower', display_name: 'Build A Tower' },
  { name: 'research', display_name: 'Research' },
  { name: 'handshake', display_name: 'Handshake' },
  { name: 'warp', display_name: 'Warp' },
  { name: 'forfeit', display_name: 'Forfeit' }
])

game_statuses = GameStatus.create([
  { name: 'not_started', display_name: 'Not Yet Started' },
  { name: 'in_progress', display_name: 'In Progress' },
  { name: 'finished', display_name: 'Finished' },
  { name: 'error', display_name: 'Error' }
])

troop_types = TroopType.create([
  { name: 'gi', display_name: 'General Infantry', base_attack: 1, base_defense: 0, base_speed: 1, base_cost: 100, base_range: 1 }
])

tower_types = TowerType.create([
  { name: 'arrow_tower', display_name: 'Arrow Tower', base_attack: 1, base_defense: 0, base_speed: 0, base_cost: 100, base_range: 2 }
])

base_types = BaseType.create([
  { name: 'fortress', display_name: 'Fortress', base_attack: 1, base_defense: 0, base_speed: 0, base_range: 2 }
])

maps = Map.create([
  { name: 'timeline', display_name: 'The Map', max_players: 2, max_player_towers: 3,
    map_template: %({ "map_base_spawns":  [ {"location": 0, "position": 0} ],
                      "map_tower_spawns": [ {"location": 5, "position": 0},
                                            {"location": 15, "position": 0},
                                            {"location": 25, "position": 0},
                                            {"location": 35, "position": 0} ],
                      "map_troop_spawns": [ {"location": 50, "position": 0} ]
                    })
  }
])

# users = User.create([
#   { username: 'ben_the_conqueror', color: '#E70E0E' },
#   { username: 'maverick', color: '#228BFF' },
#   { username: 'bane', color: '#151617' }
# ])

puts "Or not."
