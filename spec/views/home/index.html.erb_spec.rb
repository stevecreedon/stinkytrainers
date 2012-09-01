require 'spec_helper'

describe "home/index.html.erb" do
  
  it 'shows display welcome to stinky trainers on the home page' do
       render
       rendered.should have_content("Welcome to Stinky Trainers")
   end
  
end
