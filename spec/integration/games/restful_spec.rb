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
    
    describe 'adding players' do

     	it 'should display a list of check_boxes for the current users players in table#players with only the current user selected' do

         player1 = FactoryGirl.create(:user)
         player2 = FactoryGirl.create(:user)
         player3 = FactoryGirl.create(:user)
         player4 = FactoryGirl.create(:user)

         game1 = FactoryGirl.create(:game, :owner => @user)
         game2 = FactoryGirl.create(:game, :owner => @user)
         game3 = FactoryGirl.create(:game, :owner => FactoryGirl.create(:user))

         game1.players << @user
         game2.players << @user

         game1.players << player1
         game2.players << player3
         game2.players << player4
         
         game3.players << player2 #a game created by a different user and player

         visit games_path

         click_link('Create Game')

         within("div#players") do
           page.has_field?("game_player_id_#{@user.id}").should be_true
           page.find("input#game_player_id_#{@user.id}").should be_checked

           page.has_field?("game_player_id_#{player1.id}").should be_true
           page.find("input#game_player_id_#{player1.id}").should_not be_checked

           page.has_field?("game_player_id_#{player3.id}").should be_true
           page.find("input#game_player_id_#{player3.id}").should_not be_checked

           page.has_field?("game_player_id_#{player4.id}").should be_true
           page.find("input#game_player_id_#{player4.id}").should_not be_checked

           page.has_field?("game_player_id_#{player2.id}").should be_false
         end


     	end



     	it 'should display a list of check_boxes for the current users external\_players in table#players all unchecked' do

         player1 = FactoryGirl.create(:external_player)
         player2 = FactoryGirl.create(:external_player)
         player3 = FactoryGirl.create(:external_player)
         player4 = FactoryGirl.create(:external_player)

         game1 = FactoryGirl.create(:game, :owner => @user)
         game2 = FactoryGirl.create(:game, :owner => @user)
         game3 = FactoryGirl.create(:game, :owner => FactoryGirl.create(:user))

         game1.players << @user
         game2.players << @user

         game1.external_players << player1
         game2.external_players << player3
         game2.external_players << player4
         
         game3.external_players << player2

         visit games_path

         click_link('Create Game')

         within("div#external_players") do

           page.has_field?("game_external_player_id_#{player1.id}").should be_true
           page.find("input#game_external_player_id_#{player1.id}").should_not be_checked

           page.has_field?("game_external_player_id_#{player3.id}").should be_true
           page.find("input#game_external_player_id_#{player3.id}").should_not be_checked

           page.has_field?("game_external_player_id_#{player4.id}").should be_true
           page.find("input#game_external_player_id_#{player4.id}").should_not be_checked

           page.has_field?("game_external_player_id_#{player2.id}").should be_false
         end

     	end

     	it 'should submit a list of the selected players and add them to the game' do

     	   sport = FactoryGirl.create(:sport)

     	   player1 = FactoryGirl.create(:user)
         player2 = FactoryGirl.create(:user)
         player3 = FactoryGirl.create(:user)

         game = FactoryGirl.create(:game, :owner => @user)

         game.players << @user

         game.players << player1
         game.players << player2
         game.players << player3

         visit games_path

         click_link('Create Game')

         unique_location = SecureRandom.uuid

         fill_in("Location", :with => unique_location)
         select(sport.name, :from => "Sport")

         time = Time.now + 3600 

         select(time.year.to_s, :from => 'game[at(1i)]')
         select(Date::MONTHNAMES[time.month], :from => 'game[at(2i)]')
         select(time.day.to_s, :from => 'game[at(3i)]')
         select(time.hour.to_s, :from => 'game[at(4i)]')
         select(time.min.to_s, :from => 'game[at(5i)]')

         uncheck("game_player_id_#{@user.id}")
         check("game_player_id_#{player1.id}")
         check("game_player_id_#{player3.id}")

         click_button('Create Game')

         created_game = Game.find_by_location(unique_location)

         created_game.players.should =~ [player1, player3]

     	end

     	it 'should submit a list of the selected external players and add them to the game' do

        sport = FactoryGirl.create(:sport)

        player1 = FactoryGirl.create(:external_player)
        player2 = FactoryGirl.create(:external_player)
        player3 = FactoryGirl.create(:external_player)

        game = FactoryGirl.create(:game, :owner => @user)

        game.players << @user

        game.external_players << player1
        game.external_players << player2
        game.external_players << player3

        visit games_path

        click_link('Create Game')

        unique_location = SecureRandom.uuid

        fill_in("Location", :with => unique_location)
        select(sport.name, :from => "Sport")

        time = Time.now + 3600 

        select(time.year.to_s, :from => 'game[at(1i)]')
        select(Date::MONTHNAMES[time.month], :from => 'game[at(2i)]')
        select(time.day.to_s, :from => 'game[at(3i)]')
        select(time.hour.to_s, :from => 'game[at(4i)]')
        select(time.min.to_s, :from => 'game[at(5i)]')


        check("game_external_player_id_#{player1.id}")
        check("game_external_player_id_#{player3.id}")

        click_button('Create Game')

        created_game = Game.find_by_location(unique_location)

        created_game.external_players.should =~ [player1, player3]

     	end
     
    end
  
  end
  
 

  describe 'editing games' do
    
    it 'should update a valid game and redirect to the show page' do
      
      unique_location = SecureRandom.uuid
      
      game = FactoryGirl.create(:game, :owner => @user, :location => unique_location)

     	visit games_path

      within("tr[@data-row='game_#{game.id}']") do
     	  click_link('edit')
      end
      
      page.current_path.should == edit_game_path(game)
      
      page.find_field('Location').value.should have_content(game.location)
      page.find_field('Sport').text.should have_content(game.sport.name)
      
      page.find_field('game[at(1i)]').value.should have_content(game.at.year.to_s)
      page.find_field('game[at(2i)]').text.should have_content(Date::MONTHNAMES[game.at.month])
      page.find_field('game[at(3i)]').value.should have_content(game.at.day.to_s)
      page.find_field('game[at(4i)]').value.should have_content(game.at.hour.to_s)
      page.find_field('game[at(5i)]').value.should have_content(game.at.min.to_s)
      
      updated_year = game.at.year + 1
      
      page.select(updated_year.to_s, :from => "game[at(1i)]")

     	click_button('Update Game')
     
      page.current_path.should == game_path(game)
      
      updated_game = Game.find_by_location(unique_location)
      
      updated_game.at.year.should == updated_year
    end
    
    it 'should not update an invalid game and display the edit page with the invalid data' do
      
      game = FactoryGirl.create(:game, :owner => @user)

     	visit games_path

      within("tr[@data-row='game_#{game.id}']") do
     	  click_link('edit')
      end

      page.select("", :from => "Sport") #ensure the update fails
      page.fill_in("Location", :with => "Updated location")

     	click_button('Update Game')
     	
      page.find_field('Sport').text.should have_content("")
      page.find_field('Location').value.should have_content("Updated location")
      
    end
    
    describe 'updating players' do
      
      it 'should update the games players' do
        
        game1 = FactoryGirl.create(:game, :owner => @user)
        game2 = FactoryGirl.create(:game, :owner => @user)
        
        player1 = FactoryGirl.create(:user)
        player2 = FactoryGirl.create(:user)
        player3 = FactoryGirl.create(:user)
        player4 = FactoryGirl.create(:user)
        
        game1.players << @user
        game1.players << player1
        game1.players << player2
        
        game2.players << @user
        game2.players << player3
        game2.players << player4
        
        visit games_path

        within("tr[@data-row='game_#{game1.id}']") do
       	  click_link('edit')
        end
        
        page.find("input#game_player_id_#{@user.id}").should be_checked
        page.find("input#game_player_id_#{player1.id}").should be_checked
        page.find("input#game_player_id_#{player2.id}").should be_checked
        page.find("input#game_player_id_#{player3.id}").should_not be_checked
        page.find("input#game_player_id_#{player4.id}").should_not be_checked
        
        uncheck("game_player_id_#{@user.id}")
        uncheck("game_player_id_#{player1.id}")
        uncheck("game_player_id_#{player2.id}")
        check("game_player_id_#{player3.id}")
        check("game_player_id_#{player4.id}")
        
        click_button('Update Game')
        
        game1.players.reload
        game1.players.should =~ [player3, player4]
      end
      
      it 'should remove all of the games players' do
        
          game = FactoryGirl.create(:game, :owner => @user)
          
          player1 = FactoryGirl.create(:user)
          player2 = FactoryGirl.create(:user)
          player3 = FactoryGirl.create(:user)
          player4 = FactoryGirl.create(:user)

          game.players << @user
          game.players << player1
          game.players << player2
          game.players << player3
          game.players << player4

          visit games_path

          within("tr[@data-row='game_#{game.id}']") do
         	  click_link('edit')
          end

          page.find("input#game_player_id_#{@user.id}").should be_checked
          page.find("input#game_player_id_#{player1.id}").should be_checked
          page.find("input#game_player_id_#{player2.id}").should be_checked
          page.find("input#game_player_id_#{player3.id}").should be_checked
          page.find("input#game_player_id_#{player4.id}").should be_checked

          uncheck("game_player_id_#{@user.id}")
          uncheck("game_player_id_#{player1.id}")
          uncheck("game_player_id_#{player2.id}")
          uncheck("game_player_id_#{player3.id}")
          uncheck("game_player_id_#{player4.id}")

          click_button('Update Game')

          game.players.reload
          game.players.should =~ []
        
      end
      
    end
    
  end

  describe 'showing games' do
    it 'should allow users to view a game'
  end

  describe 'destroying games' do
    it 'should allow users to destroy a game and redirect them back to the index page'
  end
  
end