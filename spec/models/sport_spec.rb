require 'spec_helper'

describe Sport do
  
  let(:sport) {
      Sport.new(:name => 'Sport name')
  }

  it 'should not be valid if the name is nil' do
    sport = Sport.new(:name => nil)
    sport.valid?.should be_false
    sport.errors.to_a.should include("Name can't be blank")
  end
  
  it 'should not be valid if the name is an empty string' do
     sport = Sport.new(:name => '')
     sport.valid?.should be_false
     sport.errors.to_a.should include("Name can't be blank")
  end
  
end
