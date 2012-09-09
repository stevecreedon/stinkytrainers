class CreateGamesUsersJoinTable < ActiveRecord::Migration
  
  def change
    create_table :games_users, :id => false do |t|
      t.integer :user_id
      t.integer :game_id
    end
    
    add_index :games_users, :user_id
  	add_index :games_users, :game_id
  end
  
end
