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
      format.mobile
      format.js {render :layout => false}
    end
  end
  
  def random_joke_mobile
    @joke = Joke.random_joke
    session[:joke_id] = @joke.id
    
    respond_to do |format|
      format.mobile {render :layout => false}
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

    @joke = Joke.random_joke
    session[:joke_id] = @joke.id

    if @joke.bitly_url.nil?
      @joke.generate_bitly_url
    end
    
  end
  
end