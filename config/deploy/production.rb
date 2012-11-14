#set :rvm_ruby_string, 'ruby-1.9.3-p194'
set :rvm_ruby_string, 'ruby-1.9.3-p327'
set :rvm_path, "/usr/local/rvm"
set :rvm_bin_path, "/usr/local/rvm/bin"
#before 'deploy:setup', 'rvm:install_rvm'
#before 'deploy:setup', 'rvm:install_ruby'

set :user, "root"
set :scm_username, "echovalley"
set :deploy_to, "/var/www/#{application}"

role :web, "42.121.30.107"                          # Your HTTP server, Apache/etc
role :app, "42.121.30.107"                          # This may be the same as your `Web` server
role :db,  "42.121.30.107", :primary => true # This is where Rails migrations will run
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
