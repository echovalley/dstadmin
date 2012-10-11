require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano/ext/multistage'

set :stages, ["staging", "production"]
set :default_stage, "staging"

set :rvm_ruby_string, 'ruby-1.9.3-p194'
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

set :application, "dstadmin"
set :repository,  "git://github.com/echovalley/dstadmin.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "root"
set :scm_username, "echovalley"
#set :deploy_to, "/var/www/#{application}"

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
