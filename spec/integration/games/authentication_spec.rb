require 'spec_helper'

describe 'authentication' do
  it 'should require users to sign in when they trying to access sports' do
    user = FactoryGirl.create(:user)

    visit games_path

    page.current_path.should == new_user_session_path

    fill_in('Email', :with => user.email)
    fill_in('Password', :with => user.password)

    click_button('Sign in')

    page.current_path.should == games_path
  end
end