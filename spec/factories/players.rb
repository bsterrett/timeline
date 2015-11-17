FactoryGirl.define do
  factory :player do
    resources '1000'
    username

    trait :with_spawns do
      after(:create) do |instance|
        create_list(:map_base_spawn, 1, player: instance)
        create_list(:map_tower_spawn, 3, player: instance)
        create_list(:map_troop_spawn, 1, player: instance)
      end
    end

    trait :with_game_pieces do
      after(:create) do |instance|
        create_list(:locked_map_base_spawn, 1, player: instance)
        create_list(:locked_map_tower_spawn, 3, player: instance)
        create_list(:locked_map_troop_spawn, 1, player: instance)
        create_list(:base, 1, player: instance)
        create_list(:tower, 3, player: instance)
        create_list(:troop, 5, player: instance)
      end
    end

    trait :with_spawns_and_base do
      after(:create) do |instance|
        create_list(:locked_map_base_spawn, 1, player: instance)
        create_list(:map_tower_spawn, 3, player: instance)
        create_list(:map_troop_spawn, 1, player: instance)
        create_list(:base, 1, player: instance)
      end
    end

    factory :player_with_spawns, traits: [:with_spawns]
    factory :player_with_game_pieces, traits: [:with_game_pieces]
    factory :player_with_spawns_and_base, traits: [:with_spawns_and_base]
  end
end
