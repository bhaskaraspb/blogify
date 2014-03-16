class PostController < ApplicationController

  def index
  end

  def new
    if Post.find_by(:search_term => params[:search]).nil?
      @post = Scraper.new(params[:search]).call
    else 
      @post = Post.find_by(:search_term => params[:search])
    end  
  end

end