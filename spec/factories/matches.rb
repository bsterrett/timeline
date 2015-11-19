FactoryGirl.define do
  factory :match do
    game

    factory :match_with_users do
      ignore do
        user_count 2
      end

      after(:create) do |instance, evaluator|
        instance.users = create_list(:user, evaluator.user_count)
      end
    end
  end
end
