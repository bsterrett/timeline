FactoryGirl.define do
  sequence(:base_type_name ) { |n| "base_type_#{n}" }

  factory :base_type do
    name { generate(:base_type_name) }
    display_name { generate(:base_type_name) }
    base_attack 1
    base_defense 0
    base_range 2
    base_speed 0
  end
end
