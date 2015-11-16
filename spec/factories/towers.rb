FactoryGirl.define do
  sequence(:tower_position) { |n| n }

  factory :tower, aliases: [:living_tower] do
    tower_type
    health 1.0
    level 0
    location 0
    position { generate(:tower_position) }

    factory :dead_tower do
      health 0.0
    end

    factory :wounded_tower do
      health 0.5
    end
  end
end
