require_relative 'spec_helper'

describe Scraper do 
  let(:scraper) {Scraper.new("how to scrape google")}

  it "take a search term upon initialization" do
    expect(scraper.term).to eq("how+to+scrape+google")
  end

  it "create a search url from the term" do
    expect(scraper.search_url).to eq("http://google.com/search?q=how+to+scrape+google")  
  end

  describe "#get_urls" do 
    let(:urls) {["http://google-scraper.squabbel.com/",
                 "http://schoolofdata.org/handbook/recipes/scraper-extension-for-chrome/",
                 "http://www.scrapebox.com/google-images-scraper",
                 "http://stackoverflow.com/questions/19677543/how-can-i-scrape-google",
                 "https://groups.google.com/d/topic/scrapy-users/K9QISzH4KwA"
                ]}
    
    it "fetches the top five urls from the google search" do 
      expect(scraper.get_urls).to eq(urls)
    end
  end 

  # describe "#get_content" do 
    
  #   it "fetches the top five urls from the google search" do 
  #     expect(scraper.get_content[2]).to eq("If you are using Google Chrome there is a browser extension for scraping web pages. It’s called “Scraper” and it is easy to use. It will help you scrape a website’s content and upload the results to google docs.")
  #   end


  # end  

  describe "has_content?" do 
    let(:fake_url) { "http://schoolofdata.org/handbook/recipes/scraper-extension-for-chrome/" }
    it "makes sure the site has a paragraph with text" do 
      expect(scraper.has_content?(fake_url)).to eq(true)
    end
  end
 
end












