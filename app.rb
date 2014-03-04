class App < Sinatra::Base

  get '/' do
    erb :home
  end

  get '/new' do 
    if Post.find_by(:search_term => params[:search]).nil?
      @post = Scraper.new(params[:search]).call
    else 
      @post = Post.find_by(:search_term => params[:search])
    end  

    erb :post 
  end

end