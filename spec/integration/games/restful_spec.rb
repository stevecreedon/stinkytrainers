require 'spec_helper'

describe 'games' do
  
  before :each do
    @user = FactoryGirl.create(:user)
	  visit new_user_session_path
	  
	  fill_in('Email', :with => @user.email)
    fill_in('Password', :with => @user.password)

    click_button('Sign in')
  end
    
  describe 'listing games' do
    it 'should display a list of the games owned by the signed-in user' do
            
        other_user = FactoryGirl.create(:user)

        game1 = FactoryGirl.create(:game, :owner => @user)
        game2 = FactoryGirl.create(:game, :owner => @user)
        game3 = FactoryGirl.create(:game, :owner => other_user)
        
        visit games_path
      
        within("table#owned_games") do
          
          @user.owned_games.each do |game|
            within("tr[@data-row='game_#{game.id}']") do
              page.should have_content(game.location)
              page.should have_content(game.sport.name)
              page.should have_content(game.at)
            end
          end
          
          other_user_game = other_user.owned_games.first
          
          page.should_not have_content(other_user_game.location)
          page.should_not have_content(other_user_game.sport.name)
          page.should_not have_content(other_user_game.at)
        
        end
        
    end
    
    it 'should display a list of the games the signed-in user is playing in' do
      
        game1 = FactoryGirl.create(:game, :owner => @user)
        game2 = FactoryGirl.create(:game, :owner => @user)
        game3 = FactoryGirl.create(:game, :owner => FactoryGirl.create(:user))
          
        game1.players << @user
        game3.players << @user
        
        visit games_path
      
        within("table#games") do
           
          within("tr[@data-row='game_#{game1.id}']") do
            page.should have_content(game1.location)
            page.should have_content(game1.sport.name)
            page.should have_content(game1.at)
          end
          
          within("tr[@data-row='game_#{game3.id}']") do
            page.should have_content(game3.location)
            page.should have_content(game3.sport.name)
            page.should have_content(game3.at)
          end
          
          game_user_created = @user.games.last
          
          page.should_not have_content(game2.location)
          page.should_not have_content(game2.sport.name)
          page.should_not have_content(game2.at)
        
        end
    end
  end

  describe 'creating games' do
    
    it 'should create a new game when valid game parameters are provided and redirect to the show page' do
       
      sport = FactoryGirl.create(:sport)

     	visit games_path

     	click_link('Create Game')

     	fill_in("Location", :with => 'Wimbledon')
     	select(sport.name, :from => "Sport")

     	time = Time.now + 3600 #make it an hour from now

     	select(time.year.to_s, :from => 'game[at(1i)]')
     	select(Date::MONTHNAMES[time.month], :from => 'game[at(2i)]')
     	select(time.day.to_s, :from => 'game[at(3i)]')
     	select(time.hour.to_s, :from => 'game[at(4i)]')
     	select(time.min.to_s, :from => 'game[at(5i)]')

     	expect{
     	 click_button('Create Game')
     	}.to change{Game.count}.by(1)
      
      page.current_path.should == game_path(Game.last)
              
    end
    
    it 'should redirect users back to the new page with user input when incorrect parameters are provided' do
      
      sport = FactoryGirl.create(:sport)

     	visit games_path

     	click_link('Create Game')

     	fill_in("Location", :with => 'Wimbledon')
     	select(sport.name, :from => "Sport")

     	time = Time.now - 3600 #make it an hour in the past

     	select(time.year.to_s, :from => 'game[at(1i)]')
     	select(Date::MONTHNAMES[time.month], :from => 'game[at(2i)]')
     	select(time.day.to_s, :from => 'game[at(3i)]')
     	select(time.hour.to_s, :from => 'game[at(4i)]')
     	select(time.min.to_s, :from => 'game[at(5i)]')

     	expect{
     	 click_button('Create Game')
     	}.to change{Game.count}.by(0)
      
      page.find_field('Location').value.should have_content('Wimbledon')
      page.find_field('Sport').text.should have_content(sport.name)
      
      page.find_field('game[at(1i)]').value.should have_content(time.year.to_s)
      page.find_field('game[at(2i)]').text.should have_content(Date::MONTHNAMES[time.month])
      page.find_field('game[at(3i)]').value.should have_content(time.day.to_s)
      page.find_field('game[at(4i)]').value.should have_content(time.hour.to_s)
      page.find_field('game[at(5i)]').value.should have_content(time.min.to_s)
     
    end
  end


  describe 'editing games' do
    it 'should edit a game and update it when the values are valid'
    it 'should edit a game and return then to the edit page with their edited input when incorrect parameters are provided'
  end

  describe 'showing games' do
    it 'should allow users to view a game'
  end

  describe 'destroying games' do
    it 'should allow users to destroy a game and redirect them back to the index page'
  end
  
end