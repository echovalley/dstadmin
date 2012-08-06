# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Dstadmin::Application.initialize!
require 'will_paginate/array'

Paperclip.options[:command_path] = "/usr/local/bin"
