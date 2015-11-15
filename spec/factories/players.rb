FactoryGirl.define do
  factory :player do
    resources '1000'
    username

    trait :with_spawns do
      after(:create) do |instance|
        create_list(:map_base_spawn, 1)
        create_list(:map_tower_spawn, 3)
        create_list(:map_troop_spawn, 1)
      end
    end

    trait :with_game_pieces do
      after(:create) do |instance|
        create_list(:map_base_spawn, 1)
        create_list(:map_tower_spawn, 3)
        create_list(:map_troop_spawn, 1)
        create_list(:base, 1, player: instance)
        create_list(:tower, 3, player: instance)
        create_list(:troop, 5, player: instance)
      end
    end

    # player_with_spawns = create(:player_with_spawns)
    # player_with_game_pieces = create(:player, :with_spawns, :with_game_pieces)
  end
end
