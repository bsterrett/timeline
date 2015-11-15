FactoryGirl.define do
  sequence(:tower_position) { |n| n }

  factory :tower do
    tower_type
    health 1.0
    level 0
    location 0
    position { generate(:tower_position) }
  end
end
