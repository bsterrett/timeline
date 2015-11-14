FactoryGirl.define do
  sequence(:username) { |n| "127.0.0.#{n}" }

  factory :map do
    name 'timeline'
    display_name 'The Map'
    max_players 2
    max_player_towers 3
  end
end
