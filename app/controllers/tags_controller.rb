class TagsController < ApplicationController

  def show
    @tag = CGI.unescape(params[:id])
    @jokes = Joke.tagged_with(@tag)
    generate_title "Jokes tagged with #{@tag}"
  end

  def index
    @tags = Joke.tag_counts.sort_by(&:name)
    generate_title "All joke tags"
  end

end
