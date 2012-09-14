# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Dstadmin::Application.initialize!
require 'will_paginate/array'

Paperclip.options[:command_path] = "/usr/local/bin"

TAGGED_IMAGE_THUMBNAIL_URL = '/tagged_images/thumbnail/'
TAGGED_IMAGE_THUMBNAIL_PATH = File.dirname(__FILE__) + '/../public' + TAGGED_IMAGE_THUMBNAIL_URL

