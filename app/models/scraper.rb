# require 'wordpress_poster.rb'

class Scraper
  
  @@content_tags = ["#content", ".content", ".post-content", "article", "#mainContentColExtra", ".post-body", "main"]

  attr_accessor :term, :blog_urls

  def initialize(term)
    @original_term = term
    @term = term.downcase.gsub(" ", "+")
    @term_name = term.downcase.gsub(" ", "_")
    @blog_post = Post.new
    @blog_post.title = term
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
      /\bof|\band|\bor|\bin|\bbut|\bit|\bis|\bthe|\ba|\bto/ =~ word.downcase 
    }.join("|\\b").insert(0,"\\b")

    Regexp.new(keywords)

  end

  def find_image(content)
    content.search("img").each do |image| 
      if keywords =~ image['alt'] || keywords =~ image['title']   
        @blog_post.image = image['src']
        break 
      end   
    end
  end

  def has_content(url, index)
    begin
    content = Nokogiri::HTML(open(url))
    content_array = []
    @@content_tags.each do |tag|
      if content.search(tag)
        find_image(content)
        content.search("p").each do |p_content|
          if keywords =~ p_content.children.text
             content_array << p_content.children.text + "\n\n"
             puts p_content.children.text
             puts keywords            
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
      has_content(blog, index)
    end.compact.flatten
  end

  def clean_content
    content = @raw_content.join("</p><p>").gsub(/\n+(\n+)+/, "\n\n")
    content = "<p>" + content + "</p>"
    # file = File.open("blog_posts/#{@term_name}.html", 'w') do |f|
    #   f.write(content)
    # end
    # content
  end

  def post_to_wordpress
    wp = Rubypress::Client.new(:host => "bhaskaraspb.wordpress.com", :username => "bhaskaraspb", :password => "FAKEPASS")
    wp.newPost(:blog_id => "1", :content => { :post_status => "publish", :post_date => Time.now, :post_content => "#{@final_content}", :post_title => "#{@original_term}" })  
  end

  def call
    get_urls
    get_content
    @blog_post.content = clean_content
    @blog_post.save
    @blog_post
    # post_to_wordpress
  end
end