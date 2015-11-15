FactoryGirl.define do
  factory :game do
    map

    after(:create) do |instance|
      create_list(:player, 2)
    end
  end
end
