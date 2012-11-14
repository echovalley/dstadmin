require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano/ext/multistage'

set :stages, ["staging", "production"]
set :default_stage, "staging"

set :application, "dstadmin"
set :repository,  "git://github.com/echovalley/dstadmin.git"

set :scm, :git
set :deploy_via, :remote_cache
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
