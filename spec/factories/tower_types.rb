FactoryGirl.define do
  sequence(:tower_type_name ) { |n| "tower_type_#{n}" }

  factory :tower_type do
    name { generate(:tower_type_name) }
    display_name { generate(:tower_type_name) }
    base_attack 1
    base_defense 0
    base_speed 1
    base_cost 100
  end
end
