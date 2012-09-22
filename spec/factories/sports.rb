# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :sport do
    name { generate(:name) } 
  end
  
  sequence :name do |n|
   "sport#{n}"
  end
  
end
