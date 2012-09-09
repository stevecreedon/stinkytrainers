class CreateExternalPlayersGamesJoinTable < ActiveRecord::Migration
 
  def change
    create_table :external_players_games, :id => false do |t|
      t.integer :external_player_id
      t.integer :game_id
    end
    
    add_index :external_players_games, :external_player_id
  	add_index :external_players_games, :game_id
  end
 
end
