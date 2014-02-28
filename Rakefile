task :environment do
  require_relative 'config/environment'
end

# namespace :db do
#   task :migrate => :environment do
#     DB.tables.each do |table|
#       DB.execute("DROP TABLE #{table}")
#     end

#     Dir[File.join(File.dirname(__FILE__), "db/migrations", "*.rb")].each do |f| 
#       require f
#       migration = Kernel.const_get(f.split("/").last.split(".rb").first.gsub(/\d+/, "").split("_").collect{|w| w.strip.capitalize}.join())
#       migration.migrate(:up)
#     end
#   end
# end

task :seed => :environment do
  test1 = Scraper.new("how to make friends")
  test1.get_urls
  test2 = Scraper.new("how to torrent")
  test2.get_urls
end

task :console => :environment do
  test1 = Scraper.new("how to make friends")
  test1.get_urls
  test2 = Scraper.new("how to torrent")
  test2.get_urls
  binding.pry
end