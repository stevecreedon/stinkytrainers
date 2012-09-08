require 'spec_helper'

describe "home/index.html.erb" do
  
  it 'should display a welcome message on the Stinky Trainers on the home page' do
      render
      rendered.should have_content("Stinky trainers is a website that let's you organise your sports life")
  end
  
end
