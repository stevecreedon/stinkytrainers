require 'spec_helper'

describe DashboardController do

  describe "GET 'index'" do
       
    it "should redirect to the login page when the user is not signed-in" do
      get 'index'
      response.should redirect_to('/users/sign_in')
    end
    
    it "should render the index page when the user is signed-in" do
     sign_in :user, FactoryGirl.create(:user)
     get 'index'
     response.should be_success
    end
    
  end

end
