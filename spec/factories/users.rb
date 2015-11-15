FactoryGirl.define do
  sequence(:username) { |n| "127.0.0.#{n}" }

  factory :user do
    username
  end
end
