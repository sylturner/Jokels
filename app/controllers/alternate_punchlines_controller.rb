# -*- encoding : utf-8 -*-
class AlternatePunchlinesController < JokesController

  before_filter :attach_joke, :only => [:index, :new, :create]
  before_filter :attach_alternate_punchline, :only => [:upvote, :downvote, :is_kid_safe_toggle, :destroy, :reassign]

  def attach_joke
    @joke = Joke.find(params[:joke_id])
  end

  def attach_alternate_punchline
    @alternate_punchline = AlternatePunchline.find(params[:id])
  end

  def index
    @min = params[:min] == "true"
    if is_clean_mode?
      @alternate_punchlines = @joke.filtered_alternate_punchlines
    else
      @alternate_punchlines = @joke.alternate_punchlines
    end
    @alternate_punchlines = @alternate_punchlines.sort_by{|x| x.votes}.reverse
    respond_to do |format|
      format.html { redirect_to @joke }
      format.js {render :layout => false}
    end
  end

  def new
    @alternate_punchline = AlternatePunchline.new(:joke => @joke, :user => current_user, :is_kid_safe => true)

    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def destroy
    # only admins can delete for now
    if !current_user.nil? && current_user.is_admin
      @alternate_punchline.destroy
      respond_to do |format|
       format.html { redirect_to(root_url) }
       format.xml  { head :ok }
      end
    else
      redirect_to(@alternate_punchline, :notice => "Sorry! You can't delete that.")
    end

  end

  def reassign
    @success = false
    if !current_user.nil? && current_user.is_admin
      id = params[:user_id]

      if id.nil? || id == -1
        @alternate_punchline.user = nil
      else
        user = User.find(id)
        @alternate_punchline.user = user
      end

      @alternate_punchline.save
      @success = true
    end

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def create
    @alternate_punchline = AlternatePunchline.new(params[:alternate_punchline])
    @alternate_punchline.joke = @joke
    @alternate_punchline.user = current_user

    @alternate_punchline.is_kid_safe = params[:alternate_punchline][:is_kid_safe] == '1' && !ProfanityFilter::Base.profane?(@alternate_punchline.punchline)

    respond_to do |format|
      format.html {
        if @alternate_punchline.save
          post_joke
        else
          notice = "Something happened and it didn't save your new punchline."
        end 
        redirect_to(joke_path(@joke.id), :notice => notice)
      }
    end
  end

  def post_joke
    if current_user && params[:alternate_punchline][:auto_post] == '1'
      begin
        post_joke_to_social
        notice = "Your punchline was updated and sent to #{current_user.provider.capitalize}"
      rescue => e
        notice = "Your punchline was updated, but unable to post to  #{current_user.provider.capitalize}: " + e.to_s
      end
    end
  end

  def post_joke_to_social
    if current_user.provider == "twitter"
      # Tweet the joke
      client = Twitter::Client.new(:oauth_token => current_user.token, :oauth_token_secret => current_user.secret)
      client.update("I just added a new punchline to a joke on Jokels! " + @alternate_punchline.joke.bitly_url)
    elsif current_user.provider == "facebook"
      FGraph.publish_feed('me', :message => "I just added a new punchline to this joke on Jokels: " + @alternate_punchline.joke.question + " " + @alternate_punchline.joke.bitly_url, :access_token => current_user.token)
    end
  end

  def upvote
    if current_user
      set_voting_element_ids "ap_#{@alternate_punchline.id}"
      vote @alternate_punchline, "up"
    else
      respond_to do |format|
        format.html { redirect_to(Joke.find(params[:id]), :notice => 'Please login to vote') }
        format.js { render :layout => false }
      end
    end
  end

  def downvote
    if current_user
      set_voting_element_ids "ap_#{@alternate_punchline.id}"
      vote @alternate_punchline, "down"
    else
      respond_to do |format|
        format.html { redirect_to(Joke.find(params[:id]), :notice => 'Please login to vote') }
        format.js { render :layout => false }
      end
    end
  end

  def is_kid_safe_toggle
    if !current_user.nil? && current_user.is_admin
      @alternate_punchline.is_kid_safe = !@alternate_punchline.is_kid_safe
      @alternate_punchline.save

      respond_to do |format|
        format.js { render :layout => false}
      end
    else
      respond_to do |format|
        format.html { redirect_to(root_url, :notice => 'Please login to change whether an alternate punchline is kid safe') }
      end
    end
  end
end
