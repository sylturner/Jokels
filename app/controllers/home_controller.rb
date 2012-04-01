class HomeController < ApplicationController
  
  def index
    
    random_joke
    generate_title
      
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
  
  def refresh_joke
    random_joke
    generate_title @joke.question    
  end
  
  def privacy_policy
  end
  
  protected
  
  def random_joke

    rand_id = rand(Joke.count)
    @joke = Joke.first(:conditions => [ "id >= ? and (up_votes - down_votes) >= -2", rand_id])
    session[:joke_id] = @joke.id

    if @joke.bitly_url.nil?
      @joke.generate_bitly_url
    end
    
  end
  
end