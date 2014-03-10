require 'bundler/setup'
require 'open-uri'
require 'active_record'

Bundler.require
Bundler.setup(:default)



Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}

require_relative '../app.rb'


configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
 
  ActiveRecord::Base.establish_connection(
      :adapter => "postgresql",
      :host     => "localhost",
      :username => "user"
      :database => "app-dev"
      :encoding => 'utf8'
  )
end

configure :development do
  
 
  ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => "db/development.sqlite3"
  )
end



