No views

Models

Scraper.new(term)
  (1st para from 1st result, 2nd para from 2nd result, etc)
  ouput hash 

Splicer 
  takes in hash from Scraper
  Creates Post objets
--> Post

Post
  saves the title and body to database
  print method that prints out title and body

ActiveRecord