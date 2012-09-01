require 'spec_helper'

describe "dashboard/index.html.erb" do
  
  it 'should display welcome to stinky trainers on the home page' do
       render
       rendered.should have_content("Stinky Trainers Dashboard")
   end
  
end
