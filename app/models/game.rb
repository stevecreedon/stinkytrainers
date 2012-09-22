class Game < ActiveRecord::Base
  attr_accessible :at, :location, :sport, :owner
  
  validates :location, :presence => true
  validates :at, :presence => true
  validates :sport, :presence => true
  validates :owner, :presence => true
  
  has_and_belongs_to_many :players, :class_name => 'User', :order => "users.email ASC"
  has_and_belongs_to_many :external_players, :order => "external_players.email ASC"
  belongs_to :sport
  belongs_to :owner, :class_name => 'User'
   
  def over?
    Time.now > self.at
  end
  
end
