class HomeController < ApplicationController
  
  def index

    # easiest 'randomizing' we can do right now - grab 30 random, unique ids from jokes
    if !session[:joke_ids] || session[:joke_ids].empty?
      # store 30 random joke ids in the user's session with no dupes
      # TODO: This ONLY works if we NEVER delete jokes from the database. REMEMBER THAT.
      session[:joke_ids] = (1...Joke.count).sort_by{rand}[0,30]      
    end
    # pop the random joke ids out until there are no more
    @joke = Joke.find(session[:joke_ids].pop)

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