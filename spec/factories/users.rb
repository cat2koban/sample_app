FactoryBot.define do
  factory :user do
    name                  { "Example User" }
    email                 { "user@example.com" }
    activated             { true }
    activated_at          { Time.zone.now }
    password              { 'password' }
    password_confirmation { 'password' }

    factory :other_user do
      name                  { Faker::Name.name }
      email                 { Faker::Internet.email }
      activated             { true }
    end

    trait :michael do
      name                  { "Michael Example" }
      email                 { "michael@example.com" }
      admin                 { true }
      activated             { true }
      activated_at          { Time.zone.now }
      password              { 'password' }
      password_confirmation { 'password' }
    end

    trait :archer do
      name                  { "Sterling Archer" }
      email                 { "duchess@example.gov" }
      activated             { true }
      activated_at          { Time.zone.now }
      password              { 'password' }
      password_confirmation { 'password' }
    end
  end
end
