FactoryGirl.define do
  sequence(:troop_type_name ) { |n| "troop_type_#{n}" }

  factory :troop_type do
    name { generate(:troop_type_name) }
    display_name { generate(:troop_type_name) }
    base_attack 1
    base_defense 0
    base_speed 1
    base_range 1
    base_cost 100
  end
end
