require 'spec_helper'

describe Game do
  
  it 'should not be valid if the game has no location' do
	  game = Game.new(:location => nil)
	  game.valid?.should be_false
	  game.errors.to_a.should include("Location can't be blank")
	end

	it 'should not be valid if the game has no date' do
	  game = Game.new(:at => nil)
	  game.valid?.should be_false
	  game.errors.to_a.should include("At can't be blank")
	end
	
	it 'should not be valid if the game has no sport' do
    game = Game.new
    game.valid?.should be_false
    game.errors.to_a.should include("Sport can't be blank")
  end

	it 'should return a list of players ordered by email' do
	  sport = FactoryGirl.create(:sport)
    game = FactoryGirl.create(:game, :sport => sport)

	  andrew = FactoryGirl.create(:user, :email => 'andrew@textxyz.com')
	  zoe = FactoryGirl.create(:user, :email => 'zoe@textxyz.com')
	  mark = FactoryGirl.create(:user, :email => 'mark@textxyz.com')
	  	  
	  game.players << andrew
	  game.players << zoe
	  game.players << mark
	  
	  game.players.should == [andrew, mark, zoe]
	end

	it 'should return a list of external players ordered by email' do
	  sport = FactoryGirl.create(:sport)
    game = FactoryGirl.create(:game, :sport => sport)

	  andrew = FactoryGirl.create(:external_player, :email => 'andrew@textxyz.com')
	  zoe = FactoryGirl.create(:external_player, :email => 'zoe@textxyz.com')
	  mark = FactoryGirl.create(:external_player, :email => 'mark@textxyz.com')

	  game.external_players << andrew
	  game.external_players << zoe
	  game.external_players << mark

	  game.external_players.should == [andrew, mark, zoe]
	end

	it 'should return true if the game is in the past' do
	  game = Game.new(:at => Time.now - 100)
	  game = game.over?.should be_true
	end

	it 'should return false if the game is not in the past' do
	  game = Game.new(:at => Time.now + 100)
	  game = game.over?.should be_false
	end
	
	it 'should not be valid if the game has no owner' do
    game = Game.new
    game.valid?.should be_false
    game.errors.to_a.should include("Owner can't be blank")
  end
  
  it 'should not be valid if the game has not been saved and is in the past' do
    game = Game.new(:at => Time.now - 1000)
    game.stub(:new_record?).and_return(true)
    game.valid?
    game.errors.get(:at).should include("Cannot create a game in the past")
  end
  
  it 'should be valid if the game has been saved and is in the past' do
    game = Game.new(:at => Time.now - 1000)
    game.stub(:new_record?).and_return(false)
    game.valid?
    game.errors.get(:at).should be_nil
  end
  
  it 'should add a user to players if a user with the email exists' do
    player = FactoryGirl.create(:user)
    game = FactoryGirl.create(:game)
    game.add_new_player(player.email)
    game.players.should == [player]
  end
  
  it 'should add an external player to external players if an external player with the email exists' do
    external_player = FactoryGirl.create(:external_player)
    game = FactoryGirl.create(:game)
    game.add_new_player(external_player.email)
    game.external_players.should == [external_player]
  end
  
  it 'should create an external player and add it to external players if no user or external player exists' do
    game = FactoryGirl.create(:game)
    
    expect{
      game.add_new_player('test@testxyz.co.xy')
    }.to change{ExternalPlayer.count}.by(1)
    
    external_player = ExternalPlayer.find_by_email('test@testxyz.co.xy')
    game.external_players.should == [external_player]
  end
  
end