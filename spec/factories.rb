FactoryGirl.define do
  sequence :email do |n|
   "person#{n}@domain.com"
  end

  factory :user do
    email { generate(:email) } 
    password 'password'
  end
end