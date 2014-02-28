class Scraper
  
  @@content_tags = ["#content", ".content", ".post-content", "article"]

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
  end

  


  def clean_url(url)
    url.gsub("/url?q=","").split("&sa")[0]
  end

  def has_content?(url)
    content = Nokogiri::HTML(open(url))
    @@content_tags.each do |tag|
      if content.search(tag)
        content.search("#{tag} p").select { |p_content| p_content.children.text.length > 100} 
      end   
    end
  end

  def get_content
    blog_urls.collect do |blog|
      content = Nokogiri::HTML(open(blog))
      content.search(".content p").first.children.text
    end
  end


end


# !!content.search(".content p").first && !!(content.search(".content p").first.children.text.length > 100)