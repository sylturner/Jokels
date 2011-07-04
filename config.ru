ENV['GEM_HOME']="#{ENV['HOME']}/.gems"
ENV['GEM_PATH']="#{ENV['GEM_HOME']}:/usr/lib/ruby/gems/1.8"
require 'rubygems'
Gem.clear_paths
# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Jokels::Application
