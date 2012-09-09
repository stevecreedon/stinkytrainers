class CreateExternalPlayers < ActiveRecord::Migration
  def change
    create_table :external_players do |t|
      t.string :email

      t.timestamps
    end
  end
end
