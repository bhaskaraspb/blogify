require 'bundler/setup'
require 'open-uri'

Bundler.require

require 'active_record'

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}

# DB = ActiveRecord::Base.connection
