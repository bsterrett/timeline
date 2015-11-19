FactoryGirl.define do
  factory :game_fabricator do
    trait :match
    trait :map
    trait :users
    trait :players

    factory :used_game_fabricator do
      after(:build) do |instance|
        instance.freeze
      end
    end

    factory :valid_game_fabricator do |vgf|
      after(:build) do |instance|
        instance.map = create(:map, max_players: 2)
        instance.match = create(:match_with_users, user_count: 2)
      end
    end
  end
end
