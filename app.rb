class App < Sinatra::Base

  get '/' do
    erb :home
  end

  get '/new' do 
    if Post.find_by(:search_term => params[:search]).nil?
      s = Scraper.new(params[:search])
      @post = Post.create.tap do |t|
        t.search_term = params[:search]
        t.title = params[:search]
        t.content = s.call
      end
      @post.save
    else 
      @post = Post.find_by(:search_term => params[:search])
    end  

    erb :post 
  end

end