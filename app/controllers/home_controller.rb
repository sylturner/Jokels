class HomeController < ApplicationController

  after_filter :increment_joke_hit_counter, :only => [:index]

  def increment_joke_hit_counter
    logger.debug "Incrementing joke counter for: #{session[:joke_id]}"
    Joke.increment_counter :hit_counter, session[:joke_id]
  end

  def kiosk_mode
      find_random_joke

      @delayTime = params[:delay].nil? ? 7500 : params[:delay]
      @kiosk_mode = true

      generate_title

      respond_to do |format|
        format.html
      end
  end

  def index
    find_random_joke
    generate_title
    respond_to do |format|
      format.html
      format.js {render :layout => false }
    end
  end

  def clean_mode_on
    set_clean_mode(true)

    redirect_to root_url, :notice => "We'll only show clean jokes from now on!"
  end

  def clean_mode_off
    set_clean_mode(false)

    redirect_to root_url, :notice => "We'll let you see the real dirty stuff now!"
  end

  def add_joke
    @joke = Joke.new(:is_kid_safe => true)
    respond_to do |format|
      format.html
      format.mobile
      format.js {render :layout => false}
    end
  end

  def random_joke
    render :json => Joke.random_joke.to_json
  end

  def random_joke_metadata
    @joke = Joke.random_joke(is_clean_mode?)
    response = {}
    response["joke-path"] = joke_path(@joke)
    response["joke-id"] = @joke.id.to_s()

    render :json => response
  end

  def refresh_joke
    find_random_joke
    generate_title @joke.question
  end

  def privacy_policy
  end

  protected

  def find_random_joke

    @joke = Joke.random_joke(is_clean_mode?)
    session[:joke_id] = @joke.id

    if @joke.bitly_url.nil?
      @joke.generate_bitly_url
    end
  end
end
