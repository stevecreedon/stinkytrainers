class Game < ActiveRecord::Base
  attr_accessible :at, :location
  
  validates :location, :presence => true
  validates :at, :presence => true
  
  has_and_belongs_to_many :players, :class_name => 'User', :order => "users.email ASC"
  has_and_belongs_to_many :external_players, :order => "external_players.email ASC"
  
  def over?
    Time.now > self.at
  end
  
end
