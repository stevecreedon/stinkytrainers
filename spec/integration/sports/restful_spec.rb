require 'spec_helper'

describe 'restful' do

  before :each do
    user = FactoryGirl.create(:user)
	  visit new_user_session_path
	  fill_in('Email', :with => user.email)
    fill_in('Password', :with => user.password)

    click_button('Sign in')
  end

  describe 'showing all sports on the index page' do

    it "should list all sports" do
      FactoryGirl.create(:sport, :name => 'Tennis')
      FactoryGirl.create(:sport, :name => 'Football')

      visit sports_path

      page.should have_content('Tennis')
      page.should have_content('Football')
    end

  end
  
  describe 'adding a new sport' do

      it 'should add a valid sport and redirect to the index page' do
        visit sports_path

        click_link('New Sport')

        fill_in('Name', :with => 'Tennis')

        expect{
          click_button('Create Sport')
        }.to change{Sport.count}.by(1)
        
        page.current_path.should == sports_path
        page.should have_content('Tennis')
      end

      it 'should not add an invalid sport and should re-render the new page with the invalid data we entered' do
  	    Sport.create(:name => 'Tennis')
  	    
        visit sports_path

        click_link('New Sport')

        fill_in('Name', :with => 'Tennis')

        expect{
          click_button('Create Sport')
        }.to change{Sport.count}.by(0)
        
        #page.save_and_open_page
        
        page.find_field('Name').value.should have_content('Tennis')
        page.should have_content('has already been taken')
      end

    end
    
    describe 'destroying sport' do

      it 'should destroy a sport' do
        FactoryGirl.create(:sport, :name => 'football')
        FactoryGirl.create(:sport, :name => 'cricket')
        sport = FactoryGirl.create(:sport, :name => 'Tennis')
        FactoryGirl.create(:sport, :name => 'basketball')

        visit sports_path

        page.should have_content('Tennis')

        within("tr[@data-row='#{sport.id}']") do
          expect{
            click_link('Destroy')
          }.to change{Sport.count}.by(-1)
        end

        page.current_path.should == sports_path
        page.should_not have_content('Tennis')
      end

    end
  
  
end