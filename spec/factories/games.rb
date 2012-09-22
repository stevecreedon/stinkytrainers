# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    location { generate(:location) } 
    at { generate(:at) }
    sport { FactoryGirl.create(:sport) }   
    owner { FactoryGirl.create(:user) } 
  end
  
  sequence :location do |n|
    "location#{n}"
  end

  sequence :at do |n|
    Time.now + (n * 3600 * 24)
  end
end
