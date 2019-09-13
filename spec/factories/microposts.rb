FactoryBot.define do
  factory :micropost do
    content    { Faker::Lorem.sentence(word_count: 5) }
    association :user

    trait :most_recent do
      created_at { Time.zone.now }
    end

  end
end
