FactoryBot.define do
  factory :micropost do
    content    { Faker::Lorem.sentence(word_count: 5) }
    association :user, factory: :user

    factory :other_micropost do
      content { Faker::Lorem.sentence(word_count: 5) }
      association :user, factory: :other_user
    end

    trait :most_recent do
      created_at { Time.zone.now }
    end
  end
end
