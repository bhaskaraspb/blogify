require 'bundler/setup'
require 'open-uri'
require 'active_record'

Bundler.require
Bundler.setup(:default)



Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}

require_relative '../app.rb'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/development.sqlite3"
  )
