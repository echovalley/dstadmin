#server "my_fancy_server.com", :app, :web, :db, :primary => true
set :deploy_to, "/var/www/#{application}"

before "bundle:install" do
  run "cd #{fetch(:latest_release)} && bundle config build.pg --with-pg=/usr/pgsql-9.2"
end
