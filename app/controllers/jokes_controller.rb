# -*- encoding : utf-8 -*-
class JokesController < ApplicationController

  # set the @joke instance variable for certain methods
  before_filter :attach_joke, :only => [:new, :show, :embed, :reassign, :edit, :destroy, :update, :favorite_toggle, :upvote, :downvote, :new_sms_joke, :send_sms_joke, :is_kid_safe_toggle,  :add_tags, :save_tags]
  skip_before_filter :verify_authenticity_token, :only => [:receive_sms_request]
  skip_before_filter :is_mobile, :only => [:embed, :show_min]

  # GET /jokes
  # GET /jokes.xml
  def index
    if is_clean_mode?
      @jokes = Joke.where('is_kid_safe = 1')
    else
      @jokes = Joke.all
    end

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

    @fb_url = @joke.bitly_url
    generate_title @joke.question

    respond_to do |format|
      format.html
      format.js { render :layout => false }
      format.xml  { render :xml => @joke }
      format.json { render :json => @joke }
    end
  end

  def embed
    if @joke.bitly_url.nil?
      @joke.generate_bitly_url
    end

    respond_to do |format|
      format.html {render :layout => false}
      format.js {render :layout => false}
    end
  end

  # GET /jokes/new
  # GET /jokes/new.xml
  def new
    @joke.is_kid_safe = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @joke }
    end
  end

  # GET /jokes/1/edit
  def edit
    redirect_to(@joke, :notice => "Sorry! You can't edit this joke.") unless @joke.user == current_user
  end

  def qtip
    @joke = Joke.find(params[:id])
    generate_title @joke.question

    respond_to do |format|
      format.html {render :layout => false}#qtip.html.erb
    end
  end

  # POST /jokes
  # POST /jokes.xml
  def create
    @joke = Joke.new(params[:joke])
    if current_user
      @joke.user = current_user
      @joke.is_kid_safe = params[:joke][:is_kid_safe] == '1' && !(ProfanityFilter::Base.profane?(@joke.question) || ProfanityFilter::Base.profane?(@joke.answer))

    end
    respond_to do |format|
      if @joke.save
        notice = 'Joke was successfully created.'

        format.html {
          auto_post_joke
          redirect_to(@joke, :notice => notice)
          }
        format.mobile {
          auto_post_joke
          redirect_to(@joke, :notice => notice)
          }
        format.xml  { render :xml => @joke, :status => :created, :location => @joke }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @joke.errors, :status => :unprocessable_entity }
      end
    end
  end

  def auto_post_joke
    if current_user && params[:joke][:auto_post] == '1'
      begin
        tweet_joke
        notice = "Joke was updated and sent to #{current_user.provider.capitalize}"
      rescue => e
        notice = "Joke was updated, but unable to post to #{current_user.provider.capitalize}: " + e.to_s
      end
    end
  end

  # PUT /jokes/1
  # PUT /jokes/1.xml
  def update
    respond_to do |format|
      if @joke.user == current_user && @joke.update_attributes(params[:joke])
        @joke.is_kid_safe = params[:joke][:is_kid_safe] == '1' && !(ProfanityFilter::Base.profane?(@joke.question) || ProfanityFilter::Base.profane?(@joke.answer))
        @joke.save()
        format.html { 
          notice = 'Joke was successfully updated.'
          if current_user && params[:joke][:auto_tweet] == '1'
            begin
              tweet_joke
              notice = 'Joke was updated and sent to #{current_user.provider.capitalize}'
            rescue => e
              notice = 'Joke was updated, but unable to send to #{current_user.provider.capitalize}: ' + e.to_s
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
    # only admins can delete jokes for now.
    if !current_user.nil? && current_user.is_admin
      @joke.destroy
      respond_to do |format|
       format.html { redirect_to(root_url) }
       format.xml  { head :ok }
      end
    else
      redirect_to(@joke, :notice => "Sorry! Deleting jokes isn't allowed yet")
    end
  end

  def reassign
    @success = false
    if !current_user.nil? && current_user.is_admin
      id = params[:user_id]

      if id.nil? || id == '-1'
        @joke.user = nil
      else
        user = User.find(id)
        @joke.user = user
      end

      @joke.save
      @success = true
    end

    respond_to do |format|
      format.js {render :layout => false}
    end
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

  def is_kid_safe_toggle
    if !current_user.nil? && current_user.is_admin
      @joke.is_kid_safe = !@joke.is_kid_safe
      @joke.save

      respond_to do |format|
        format.js { render :layout => false}
      end
    else
      respond_to do |format|
        format.html { redirect_to(root_url, :notice => 'Please login to change whether a joke is kid safe') }
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

  def new_sms_joke
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def send_sms_joke
    if params[:phone].length > 10 || params[:phone] =~ /\D/
      respond_to do |format|
        format.html { redirect_to(@joke, :notice => "Invalid phone number. Only use numbers. Don't use spaces, symbols, animals, or letters.") }
      end
    else
      #begin
        @joke.sms_joke params[:phone]
        respond_to do |format|
          format.html { redirect_to(@joke, :notice => "Joke sent through SMS!") }
        end
      # rescue => e
      #   respond_to do |format|
      #     format.html { redirect_to(@joke, :notice => "Sorry. There was some kind of problem sending your SMS. You can try again, see if that works.") }
      #   end
      # end
    end
  end

  def receive_sms_request
    body = params[:Body]
    number = params[:From]

    logger.debug "Body of text: " + body
    logger.debug "From number: " + number

    body.downcase! #to lower case
    message_sent = false

    if (body.include? "jokel me") || (body.include? "joke me")
      joke = Joke.random_joke
      joke.sms_joke number
      message_sent = true
    end

    respond_to do |format|
      format.html {render :layout => false, :notice => message_sent ? "Message Sent" : "Message not sent, body is probably wrong fromat."}
    end
  end

  def add_tags
  end

  def save_tags
    return if params[:tags].nil?

    tags = params[:tags].gsub(".","").split(",")
    @joke.tag_list = tags

    if @joke.save
      respond_to do |format|
        format.html { redirect_to(@joke, :notice => "Tagged that joke!") }
      end
    else
      respond_to do |format|
        format.html { redirect_to(@joke, :notice => "Couldn't tag the joke. Not sure why...")}
      end
    end
  end

end
