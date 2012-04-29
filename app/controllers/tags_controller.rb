class TagsController < ApplicationController

  def show
    @tag = CGI.unescape(params[:id])
    @jokes = Joke.tagged_with(@tag)
    generate_title "Jokes about #{@tag}"
  end

  def index
    @tags = Joke.tag_counts.sort_by(&:name)
    generate_title "All joke tags"
  end

  def search    
    autocomplete_tags = []
    if params[:term]
      Joke.tag_counts.where("name like ?", "%#{params[:term]}%").sort_by(&:name).each{|tag| autocomplete_tags << tag.name}
    else
      Joke.tag_counts.sort_by(&:name).each{|tag| autocomplete_tags << tag.name}
    end
    respond_to do |format|
      format.html {redirect_to root_path}
      format.json {render :json => autocomplete_tags.to_json}
    end    
  end

end
