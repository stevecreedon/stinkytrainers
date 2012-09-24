class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :games
  
  has_many :players, :through => :games, :uniq => true
  has_many :external_players, :through => :games, :uniq => true
  
  has_many :owned_games, :class_name => 'Game', :foreign_key => :owner_id
end
