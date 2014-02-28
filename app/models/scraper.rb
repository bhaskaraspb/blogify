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

    @blog_urls = blog_urls.collect { |b| clean_url(b) }
    @blog_urls = blog_urls.reject do |blog_url|
      /search\\?/.match(blog_url) ||  blog_url !~ /http/ || blog_url =~ /youtube/ 
      end
    @blog_urls = blog_urls.reject do |blog_url|
      puts blog_url
      !has_content?(blog_url) 
    end.slice(0,5)

  end


  def clean_url(url)
    url.gsub("/url?q=","").split("&sa")[0]
  end

  def has_content?(url)
    content = Nokogiri::HTML(open(url))
    !!content.search(".content p") || !!content.search(".content p").first.children.text.length > 100
  end


end