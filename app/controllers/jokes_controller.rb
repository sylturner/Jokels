class JokesController < ApplicationController
  # GET /jokes
  # GET /jokes.xml
  def index
    @jokes = Joke.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jokes }
    end
  end

  # GET /jokes/1
  # GET /jokes/1.xml
  def show
    @joke = Joke.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @joke }
    end
  end

  # GET /jokes/new
  # GET /jokes/new.xml
  def new
    @joke = Joke.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @joke }
    end
  end

  # GET /jokes/1/edit
  def edit
    @joke = Joke.find(params[:id])
    redirect_to(@joke, :notice => "Sorry! Editing jokes isn't allowed yet")
  end

  # POST /jokes
  # POST /jokes.xml
  def create
    @joke = Joke.new(params[:joke])
    if current_user
      @joke.user = current_user
    end
    respond_to do |format|
      if @joke.save
        format.html { redirect_to(@joke, :notice => 'Joke was successfully created.') }
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
    @joke = Joke.find(params[:id])

    respond_to do |format|
      if @joke.update_attributes(params[:joke])
        format.html { redirect_to(@joke, :notice => 'Joke was successfully updated.') }
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
    @joke = Joke.find(params[:id])
    redirect_to(@joke, :notice => "Sorry! Deleting jokes isn't allowed yet")
    #@joke.destroy

    #respond_to do |format|
    #  format.html { redirect_to(jokes_url) }
    #  format.xml  { head :ok }
    #end
  end
end
