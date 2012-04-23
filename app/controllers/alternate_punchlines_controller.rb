class AlternatePunchlinesController < JokesController

  before_filter :attach_joke, :only => [:index, :new, :create]  
  before_filter :attach_alternate_punchline, :only => [:upvote, :downvote, :is_kid_safe_toggle]

  def attach_joke
    @joke = Joke.find(params[:joke_id])
  end

  def attach_alternate_punchline
    @alternate_punchline = AlternatePunchline.find(params[:id])
  end

  def index
    if is_clean_mode?
      @alternate_punchlines = @joke.filtered_alternate_punchlines
    else
      @alternate_punchlines = @joke.alternate_punchlines
    end
    @alternate_punchlines.sort_by!{|x| x.votes}.reverse!
    respond_to do |format|
      format.html
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

  def create
    @alternate_punchline = AlternatePunchline.new(params[:alternate_punchline])
    @alternate_punchline.joke = @joke
    @alternate_punchline.user = current_user

    @alternate_punchline.is_kid_safe = params[:alternate_punchline][:is_kid_safe] == 1 && !ProfanityFilter::Base.profane?(@alternate_punchline.punchline) 

    respond_to do |format|
      format.html {
        if @alternate_punchline.save
          notice = 'Your new punchline has been added!'        
        else
          notice = "Something happened and it didn't save your new punchline."
        end 
        redirect_to(joke_path(@joke.id), :notice => notice)
      }
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