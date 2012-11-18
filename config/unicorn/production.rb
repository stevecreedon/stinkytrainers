# Set your full path to application.
app_path = "/var/www/stinkytrainers/current"

# Set unicorn options
worker_processes 2

timeout 30

# socket for nginx
listen "#{app_path}/tmp/unicorn.sock", :backlog => 64

# Spawn unicorn master worker for user deploy (group: deploy)
user 'deploy', 'deploy'

# Fill path to your app
working_directory app_path

# Should be 'production' by default, otherwise use other env 
rails_env = ENV['RAILS_ENV'] || 'production'

# Set the path of the log files inside the log folder of the testapp
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

pid "#{app_path}/tmp/pids/unicorn.pid"


