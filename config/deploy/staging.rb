#server "my_fancy_server.com", :app, :web, :db, :primary => true

set :user, "root"
set :scm_username, "echovalley"
set :deploy_to, "/var/www/#{application}"

role :web, "192.168.0.183"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.183"                          # This may be the same as your `Web` server
role :db,  "192.168.0.183", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

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

before "bundle:install" do
  run "cd #{fetch(:latest_release)} && bundle config build.pg --with-pg=/usr/pgsql-9.2"
end
