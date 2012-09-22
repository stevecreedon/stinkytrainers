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
  end

  def update
  end

  def edit
  end

  def show
  end

  def destroy
  end
end
