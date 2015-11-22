FactoryGirl.define do
  factory :map do
    name 'timeline'
    display_name 'The Map'
    max_players 2
    max_player_towers 3
    map_template %({  "map_base_spawns":  [ {"location": 0, "position": 0} ],
                      "map_tower_spawns": [ {"location": 5, "position": 0},
                                            {"location": 15, "position": 0},
                                            {"location": 25, "position": 0},
                                            {"location": 35, "position": 0} ],
                      "map_troop_spawns": [ {"location": 50, "position": 0} ]
                    })
  end
end
