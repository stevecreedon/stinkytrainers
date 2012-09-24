class Game < ActiveRecord::Base
  attr_accessible :at, :location, :sport, :owner, :sport_id, :player_ids, :external_player_ids

  validates :location, :presence => true
  validates :at, :presence => true
  validates :sport, :presence => true
  validates :owner, :presence => true
  
  has_and_belongs_to_many :players, :class_name => 'User', :order => "users.email ASC"
  has_and_belongs_to_many :external_players, :order => "external_players.email ASC"
  belongs_to :sport
  belongs_to :owner, :class_name => 'User'
  
  validate :cannot_create_a_game_in_the_past, :on => :create
   
  def over?
    Time.now > self.at
  end

  def add_new_player(email)
    
    if (player = User.find_by_email(email))
      players << player
      return
    end
    
    if (player = ExternalPlayer.find_by_email(email))
      external_players << player
      return
    end
    
    external_players.create!(:email => email)
    
  end
  
  private
  
  def cannot_create_a_game_in_the_past
    return unless self.at
    self.errors.add(:at, 'Cannot create a game in the past') if self.over?
  end

end
