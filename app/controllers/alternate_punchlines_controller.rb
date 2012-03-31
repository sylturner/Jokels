class AlternatePunchlinesController < JokesController

  before_filter :attach_joke, :only => [:index, :new, :create]  

  def attach_joke
    @joke = Joke.find(params[:joke_id])
  end

  def index
    @alternate_punchlines = @joke.alternate_punchlines.sort_by{|x| x.votes}.reverse
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def new
    @alternate_punchline = AlternatePunchline.new(:joke => @joke, :user => current_user)
    
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @alternate_punchline = AlternatePunchline.new(params[:alternate_punchline])
    @alternate_punchline.joke = @joke
    @alternate_punchline.user = current_user
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
    @alternate_punchline = AlternatePunchline.find(params[:id])
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
    @alternate_punchline = AlternatePunchline.find(params[:id])
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
end