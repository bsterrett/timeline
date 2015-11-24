FactoryGirl.define do
  sequence(:username) { |n| "127.0.0.#{n}" }

  factory :user do
    username
    color '#000000'
  end
end
