FactoryGirl.define do
  sequence(:base_position) { |n| n }

  factory :base, aliases: [:living_base] do
    health 1.0
    level 0
    location 0
    position { generate(:base_position) }

    factory :dead_base do
      health 0.0
    end

    factory :wounded_base do
      health 0.5
    end
  end
end
