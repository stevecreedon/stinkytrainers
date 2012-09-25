class GamesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @owned_games = current_user.owned_games
    @games = current_user.games
  end

  def new
    @game = Game.new
    @game.players << current_user
  end

  def create
    @game = Game.new(params[:game])
    @game.owner = current_user
    
    if @game.save
      @game.add_new_player(params[:new_player]) unless params[:new_player].blank?
  		redirect_to game_path(@game)
  	else
  		render :template => 'games/new.html.erb'
  	end
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to game_path(@game)
    else
      render :template => 'games/edit.html.erb'
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def show
  end

  def destroy
  end
end
