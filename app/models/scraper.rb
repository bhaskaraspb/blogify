class Scraper
  
  @@content_tags = ["#content", ".content", ".post-content", "article", "#mainContentColExtra", ".post-body", "main"]

  attr_accessor :term, :blog_urls

  def initialize(term)
    @term = term.downcase.gsub(" ", "+")
    @term_name = term.downcase.gsub(" ", "_")
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

  def keywords
    keywords = term.split("+").reject { |word|
      /\bof|\band|\bor|\bbut|\bit|\bis|\bthe|\ba|\bto/ =~ word.downcase 
    }.join("|\\b")

    keywords = "\\b" + keywords

    Regexp.new(keywords)

  end

  def has_content(url, index)
    begin
    content = Nokogiri::HTML(open(url))
    content_array = []
    @@content_tags.each do |tag|
      if content.search(tag)
        content.search("p").each do |p_content|
          if keywords =~ p_content.children.text
             content_array << p_content.children.text + "\n\n"
             puts p_content.children.text
             break
          else
            next
          end
        end
        break
      else 
        next
      end   
    end
    flat_non_nil_array = content_array.flatten.compact
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        "This page did not exist"
      else
        "There was a non 404 error"
      end
    end
    flat_non_nil_array
  end

  def get_content
    @raw_content = blog_urls.each_with_index.collect do |blog, index|
      puts blog
      # puts has_content(blog, index)
      has_content(blog, index)
    end.compact.flatten
  end

  def clean_content
    File.open("blog_posts/#{@term_name}.txt", 'w') do |f|
      f.write(@raw_content.join("").gsub(/\n+(\n+)+/, "\n\n"))

    end
  end

  def call
    get_urls
    get_content
    clean_content
  end
end

# !!content.search(".content p").first && !!(content.search(".content p").first.children.text.length > 100)