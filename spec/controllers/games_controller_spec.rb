require 'spec_helper'

describe GamesController do
  
  it 'should call add_new_player on creating a valid game when a new player email is provided' do
 	  
 	  sign_in :user, FactoryGirl.create(:user)
 	  
 	  game = FactoryGirl.create(:game)
 	  game.stub(:save).and_return(true)
 	  game.should_receive(:add_new_player).with('test@yxz.wx.yz')
 	  Game.stub(:new).with('game params').and_return(game)

 	  post 'create', :new_player => 'test@yxz.wx.yz', :game => 'game params'
 	  
  end
  
   it 'should not call add_new_player on creating a valid game when a new player email is not provided' do
   	  
   	sign_in :user, FactoryGirl.create(:user)

  	game = FactoryGirl.create(:game)
  	game.stub(:save).and_return(true)
  	game.should_receive(:add_new_player).with(anything).never
  	Game.stub(:new).with('game params').and_return(game)

  	post 'create', :game => 'game params'
   	   
 	 end
 	  
 	it 'should not call add_new_player on creating an invalid game even when a new player email is provided' do
   	  
   	sign_in :user, FactoryGirl.create(:user)

   	game = FactoryGirl.create(:game)
   	game.stub(:save).and_return(false)
   	game.should_receive(:add_new_player).with('test@yxz.wx.yz').never
   	Game.stub(:new).with('game params').and_return(game)

   	post 'create', :new_player => 'test@yxz.wx.yz', :game => 'game params'
   	
 	end
  
  
end