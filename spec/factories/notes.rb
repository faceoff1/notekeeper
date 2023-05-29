FactoryBot.define do
  factory :note do
    content { Faker::Hipster.sentence }
    association :user, factory: :user
  end
end
