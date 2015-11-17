FactoryGirl.define do
  sequence(:map_base_spawn_location) { |n| (n-1)*5 }
  sequence(:map_base_spawn_position) { |n| n-1 }

  factory :map_base_spawn, aliases: [:unlocked_map_base_spawn, :spawn_unlocked_map_base_spawn] do
    player
    spawn_locked false
    location { generate(:map_base_spawn_location) }
    position { generate(:map_base_spawn_position) }

    factory :locked_map_base_spawn, aliases: [:spawn_locked_map_base_spawn] do
      spawn_locked true
    end
  end
end
