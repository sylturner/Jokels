class HomeController < ApplicationController
  
  def index
    # get a random joke
    @joke = Joke.all[rand(Joke.all.size)]    
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @jokes }
    end
  end
  
  def add_joke
    @joke = Joke.new
    
  end
  
  
end