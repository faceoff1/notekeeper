FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    fullname { Faker::Name.name }
    after(:build) { |u| u.password_confirmation = u.password = Devise.friendly_token }
  end
end
