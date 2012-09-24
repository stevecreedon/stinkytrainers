# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :external_player do
    email{ generate(:email) }
  end
end
