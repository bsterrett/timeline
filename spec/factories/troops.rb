FactoryGirl.define do
  factory :troop, aliases: [:living_troop] do
    troop_type
    health 1.0
    level 0
    location 0

    factory :dead_troop do
      health 0.0
    end

    factory :wounded_troop do
      health 0.5
    end
  end
end
