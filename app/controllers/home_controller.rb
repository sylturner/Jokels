class HomeController < ApplicationController
  
  def index
    
    rand_id = rand(Joke.count)
    @joke = Joke.first(:conditions => [ "id >= ?", rand_id])
    session[:joke_id] = @joke.id

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
  
  def privacy_policy
  end
  
end