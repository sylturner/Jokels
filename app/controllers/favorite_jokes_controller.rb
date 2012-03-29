class FavoriteJokesController < ApplicationController
  # GET /favorite_jokes
  # GET /favorite_jokes.xml
  def index
    @favorite_jokes = FavoriteJoke.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favorite_jokes }
    end
  end

  # GET /favorite_jokes/1
  # GET /favorite_jokes/1.xml
  def show
    @favorite_joke = FavoriteJoke.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favorite_joke }
    end
  end

  # GET /favorite_jokes/new
  # GET /favorite_jokes/new.xml
  def new
    @favorite_joke = FavoriteJoke.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favorite_joke }
    end
  end

  # GET /favorite_jokes/1/edit
  def edit
    @favorite_joke = FavoriteJoke.find(params[:id])
  end

  # POST /favorite_jokes
  # POST /favorite_jokes.xml
  def create
    @favorite_joke = FavoriteJoke.new(params[:favorite_joke])

    respond_to do |format|
      if @favorite_joke.save
        format.html { redirect_to(@favorite_joke, :notice => 'Favorite joke was successfully created.') }
        format.xml  { render :xml => @favorite_joke, :status => :created, :location => @favorite_joke }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @favorite_joke.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /favorite_jokes/1
  # PUT /favorite_jokes/1.xml
  def update
    @favorite_joke = FavoriteJoke.find(params[:id])

    respond_to do |format|
      if @favorite_joke.update_attributes(params[:favorite_joke])
        format.html { redirect_to(@favorite_joke, :notice => 'Favorite joke was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favorite_joke.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favorite_jokes/1
  # DELETE /favorite_jokes/1.xml
  def destroy
    @favorite_joke = FavoriteJoke.find(params[:id])
    @favorite_joke.destroy

    respond_to do |format|
      format.html { redirect_to(favorite_jokes_url) }
      format.xml  { head :ok }
    end
  end
end
