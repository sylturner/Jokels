class JokesController < ApplicationController

  # set the @joke instance variable for certain methods
  before_filter :attach_joke, :only => [:new, :show, :edit, :destroy, :update, :favorite_toggle, :upvote, :downvote]

  # GET /jokes
  # GET /jokes.xml
  def index
    @jokes = Joke.all
    generate_title "All Jokes"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jokes }
    end
  end

  # GET /jokes/1
  # GET /jokes/1.xml
  def show    
    session[:joke_id] = @joke.id
    if @joke.bitly_url.nil?
      @joke.generate_bitly_url
    end
    
    generate_title @joke.question
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @joke }
    end
  end

  # GET /jokes/new
  # GET /jokes/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @joke }
    end
  end

  # GET /jokes/1/edit
  def edit    
    redirect_to(@joke, :notice => "Sorry! You can't edit this joke.") unless @joke.user == current_user
  end

  # POST /jokes
  # POST /jokes.xml
  def create
    @joke = Joke.new(params[:joke])
    if current_user
      @joke.user = current_user
      if params[:joke][:auto_post]
      end
    end
    respond_to do |format|
      if @joke.save
        notice = 'Joke was successfully created.'
        
        format.html { 
          if current_user && params[:joke][:auto_post] == '1'
           begin
              tweet_joke
              notice = "Joke was updated and sent to #{current_user.provider.capitalize}"
            rescue => e
              notice = "Joke was updated, but unable to post to #{current_user.provider.capitalize}: " + e.to_s
            end
          end
          redirect_to(@joke, :notice => notice) 
          
          }
        format.xml  { render :xml => @joke, :status => :created, :location => @joke }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @joke.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jokes/1
  # PUT /jokes/1.xml
  def update
    respond_to do |format|
      if @joke.update_attributes(params[:joke])
        format.html { 
          notice = 'Joke was successfully updated.'
          if current_user && params[:joke][:auto_tweet] == '1'
            begin
              tweet_joke
              notice = 'Joke was updated and sent to Twitter'
            rescue => e
              notice = 'Joke was updated, but unable to send to Twitter: ' + e.to_s
            end
            
          end
          redirect_to(@joke, :notice => notice) 
          }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @joke.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jokes/1
  # DELETE /jokes/1.xml
  def destroy
    redirect_to(@joke, :notice => "Sorry! Deleting jokes isn't allowed yet")
    #@joke.destroy

    #respond_to do |format|
    #  format.html { redirect_to(jokes_url) }
    #  format.xml  { head :ok }
    #end
  end
  
  def favorite_toggle
    if current_user
      current_user.toggle_favorite(@joke)
      
      respond_to do |format|
        format.html
        format.js {render :layout => false}
      end
    else
      respond_to do |format|
        format.html { redirect_to(Joke.find(params[:id]), :notice => 'Please login to favorite') }
        format.js { render :layout => false}
      end
    end
  end
  
  def upvote
    if current_user
      set_voting_element_ids "joke_#{@joke.id}"      
      vote @joke, "up"
    else
      respond_to do |format|
        format.html { redirect_to(Joke.find(params[:id]), :notice => 'Please login to vote') }
        format.js { render :layout => false }
      end
    end
  end
  
  def downvote
    if current_user
      set_voting_element_ids "joke_#{@joke.id}"
      vote @joke, "down"
    else
      respond_to do |format|
        format.html { redirect_to(Joke.find(params[:id]), :notice => 'Please login to vote') }
        format.js { render :layout => false }
      end
    end
  end
  
  def vote joke, dir          
    begin
      if dir == "up"
        current_user.up_vote(joke)
      else
        current_user.down_vote(joke)
      end
      @vote_total = joke.votes
    rescue MakeVoteable::Exceptions::AlreadyVotedError
      redirect_to(@joke, :notice => "You already voted this way. Who are you trying to fool?")
    end
    
    respond_to do |format|
      format.html 
      format.js {render :layout => false}
    end
  end

  def set_voting_element_ids id
    @up_arrow_id = "up_arrow_#{id}"
    @down_arrow_id = "down_arrow_#{id}"
    @vote_total_id = "vote_total_#{id}"
  end
  
  def feed
    @jokes = Joke.find(:all, :order => "id DESC", :limit => 25)
    respond_to do |format|
       format.atom
     end
    
  end
  
  def tweet_joke
    if current_user.provider == "twitter"
      # Tweet the joke            
      client = Twitter::Client.new(:oauth_token => current_user.token, :oauth_token_secret => current_user.secret)
      client.update(@joke.question + " " + @joke.bitly_url)
    elsif current_user.provider == "facebook"
      FGraph.publish_feed('me', :message => @joke.question + " " + @joke.bitly_url, :access_token => current_user.token)
    end
  end

  # set the joke from the params, returns a new one if there is no joke with that id
  def attach_joke
    @joke = Joke.find(params[:id]) || Joke.new
  end
end
