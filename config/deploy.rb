require "bundler/capistrano"
require 'capistrano-tools'

#hostname = '192.168.0.12'
hostname = '176.58.113.5'
server hostname, :app, :web, :db, :primary => true

set :application,  "stinkytrainers"
set :repository,   "git://github.com/stevecreedon/stinkytrainers.git"
set :branch,       "master"
set :scm,          :git
set :deploy_to,    "/var/www/stinkytrainers"
set :user,         "deploy"
set :use_sudo,     false

set :templater, :templates => ['database']

role :web, hostname                          # Your HTTP server, Apache/etc
role :app, hostname                          # This may be the same as your `Web` server
role :db,  hostname, :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

after 'deploy:restart', 'unicorn:reload'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

