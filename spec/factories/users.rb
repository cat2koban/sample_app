FactoryBot.define do
  factory :michael, class: User do
    name                  { "Michael Example" }
    email                 { "michael@example.com" }
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }
    password              { 'password' }
    password_digest       { User.digest('password') }
    password_confirmation { 'password' }
  end

  factory :archer, class: User do
    name                  { "Sterling Archer" }
    email                 { "duchess@example.gov" }
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }
    password              { 'password' }
    password_digest       { User.digest('password') }
    password_confirmation { 'password' }
  end
end
