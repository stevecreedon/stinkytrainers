require 'spec_helper'

describe ExternalPlayer do
  
  it 'should not be valid if the player has no email' do
  	external_player = ExternalPlayer.new(:email => nil)
  	external_player.valid?.should be_false
  	external_player.errors.to_a.should include("Email can't be blank")
  end

  it 'should not be valid if the email already exists' do
    ExternalPlayer.create(:email => 'bolt@lighting.co.uk')

    external_player = ExternalPlayer.new(:email => 'bolt@lighting.co.uk')
    external_player.valid?.should be_false
  	external_player.errors.to_a.should include("Email has already been taken")
  end
  
end