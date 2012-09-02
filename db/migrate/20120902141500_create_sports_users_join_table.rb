class CreateSportsUsersJoinTable < ActiveRecord::Migration
  def up
  	create_table :sports_users, :id => false do |t|
  	  t.integer :user_id
  	  t.integer :sport_id
  	end

  	add_index :sports_users, :sport_id
  	add_index :sports_users, :user_id
  end

  def down
  	drop_table :sports

  	remove_index :sports_users, :sport_id
  	remove_index :sports_users, :user_id
    end
end
