class ExternalPlayer < ActiveRecord::Base
  attr_accessible :email
  
  validates :email, :presence => true, :uniqueness => true
  
  has_and_belongs_to_many :games
end
