# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['Tennis', 'Badminton', 'Golf', 'Squash', 'Ping Pong'].each do | name |
  Sport.create!(:name => name) unless Sport.find_by_name(name)
end
