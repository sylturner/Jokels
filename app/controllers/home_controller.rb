class HomeController < ApplicationController
  
  def index
    # get a random joke
    @joke = Joke.all[rand(Joke.all.size)]    
    
    respond_to do |format|
      format.html 
      format.js {render :layout => false }
    end
  end
  
  def add_joke
    @joke = Joke.new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end   
end