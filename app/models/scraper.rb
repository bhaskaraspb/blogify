class Scraper
  attr_accessor :term, :blog_urls

  def initialize(term)
    @term = term.downcase.gsub(" ", "+")
  end

  def search_url
    "http://google.com/search?q=#{@term}"
  end

  def get_urls
    index_doc = Nokogiri::HTML(open(search_url))
    @blog_urls = index_doc.search("li.g a").collect{|e| e.attribute("href").value}
    @blog_urls = blog_urls.slice(0,5)
  end

  def get_splices
    blog_urls.collect do |blog_url|
      blog_doc = Nokogiri::HTML(open(blog_url))
      blog = blog_doc.search("#content p:first").collect{|e| e.attribute("href").value}
    end
  end
end