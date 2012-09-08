class SportsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @sports = Sport.all
  end

  def new
    @sport = Sport.new
  end

  def create
    @sport = Sport.new(params[:sport])
    
   	if @sport.save
  		redirect_to(sports_path)
  	else
  		render :template => 'sports/new.html.erb'
  	end
  end

  def destroy
    Sport.destroy(params[:id])
    redirect_to(sports_path)
  end
end
