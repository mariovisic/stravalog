# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

# Enable gzip compression for heroku. If running your own HTTP server like
# nginx or apache it's best to disable this and handle it yourself.
use Rack::Deflater 
run Rails.application
