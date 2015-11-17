FactoryGirl.define do
  sequence(:map_troop_spawn_location) { |n| (n)*5 }
  sequence(:map_troop_spawn_position) { |n| n-1 }

  factory :map_troop_spawn, aliases: [:unlocked_map_troop_spawn, :spawn_unlocked_map_troop_spawn] do
    player
    spawn_locked false
    location { generate(:map_troop_spawn_location) }
    position { generate(:map_troop_spawn_position) }

    factory :locked_map_troop_spawn, aliases: [:spawn_locked_map_troop_spawn] do
      spawn_locked true
    end
  end
end
