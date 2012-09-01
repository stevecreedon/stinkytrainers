require 'spec_helper'

describe 'only registered users can access dashboard' do

  it 'should require users to sign in when they trying to access dashboard' do
    user = FactoryGirl.create(:user)

    visit dashboard_index_url

    page.current_path.should == new_user_session_path

    # 'Email' and 'Password' are the text in the HTML labels on the sign in screen
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => user.password)

    click_button('Sign in')

    page.current_path.should == dashboard_index_path
  end
  
  it 'should allow users without an account to sign-up then access the dashboard' do
    
    visit dashboard_index_url

    page.current_path.should == new_user_session_path

    click_link('Sign up')
    
    page.current_path.should == new_user_registration_path

    # 'Email' and 'Password' are the text in the HTML labels on the sign in screen
    fill_in('Email', :with => 'joe@bloggsxyz.com')
    fill_in('Password', :with => 'JoeBlogg1')
    fill_in('Password confirmation', :with => 'JoeBlogg1')

    click_button('Sign up')

    page.current_path.should == dashboard_index_path
  end
 
end