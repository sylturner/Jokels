class LeaderboardController < ApplicationController
  before_filter :set_cache_buster

  # Adding a cachebuster so that going back to the leaderboard index will force a refresh
  # http://blog.serendeputy.com/posts/how-to-prevent-browsers-from-caching-a-page-in-rails/
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def index 
     #sorting from highest to lowest for the past week is the default behavior  
     @time = params[:time] || "week"
     @sort_type = params[:sort_type] || "joke"
     @sort = params[:sort] || "top"
     @view = params[:view] || "list"
     
     @jokes = Array.new
     @users = Array.new

     if @sort == "most" && @sort_type == "joke"
        @sort = "top"
     end

     if @view == "feed" && @sort_type == "user"
      @view = "list"
     end 

     if @view == "list"
       if @sort_type == "joke"
         @jokes = get_joke_list(@sort, @time)
       elsif @sort_type == "user"
         sort_direction_text = @sort == "bottom" ? "ASC" : "DESC"

         @users = nil
         user_jokes = Array.new
         
         if @sort == "most"
           case @time
            when "today"
              user_jokes = Joke.select("user_id, count(id) as total_jokes").where(['user_id is not null and created_at BETWEEN ? AND ?', Date.today, Date.tomorrow - 1.minute]).group("user_id").having("count(1) > 0").order("total_jokes DESC").limit(10)
            when "week"
              user_jokes = Joke.select("user_id, count(id) as total_jokes").where(['user_id is not null and created_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now]).group("user_id").having("count(1) > 0").order("total_jokes DESC").limit(10)
            when "month"
              user_jokes = Joke.select("user_id, count(id) as total_jokes").where(['user_id is not null and created_at BETWEEN ? AND ?', Time.now.beginning_of_month, Time.now]).group("user_id").having("count(1) > 0").order("total_jokes DESC").limit(10)
            when "all-time"
              user_jokes = Joke.select("user_id, count(id) as total_jokes").where("user_id is not null").group("user_id").order("total_jokes DESC").limit(10)
            end
         elsif @sort == "newest"
           @users = User.all.reverse[0...10]
         else
           case @time
           when "today"
             user_jokes = Joke.select("user_id, sum((up_votes - down_votes)) as total_votes").where(['user_id is not null and created_at BETWEEN ? AND ?', Date.today, Date.tomorrow - 1.minute]).group("user_id").having("count(id) > 0").order("total_votes #{sort_direction_text}").limit(10)
           when "week"
             user_jokes = Joke.select("user_id, sum((up_votes - down_votes)) as total_votes").where(['user_id is not null and created_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now]).group("user_id").having("count(id) > 0").order("total_votes #{sort_direction_text}").limit(10)
           when "month"
             user_jokes = Joke.select("user_id, sum((up_votes - down_votes)) as total_votes").where(['user_id is not null and created_at BETWEEN ? AND ?', Time.now.beginning_of_month, Time.now]).group("user_id").having("count(id) > 0").order("total_votes #{sort_direction_text}").limit(10)
           when "all-time"
             user_jokes = Joke.select("user_id, sum((up_votes - down_votes)) as total_votes").where("user_id is not null").group("user_id").order("total_votes #{sort_direction_text}").limit(10)
           end
         end
        
        if @users.nil? 
          @users = Array.new
          user_jokes.each do |user_joke|
            @users.push(user_joke.user)
          end
        end
          
       end
    elsif @view == "feed"
      # if the index param is nil, then we need to referesh the joke list
      if params[:index].nil? 
        @index = 0
        joke_list = get_joke_list(@sort, @time)
        joke_id_list = []
        joke_list.each {|joke| joke_id_list.push(joke.id)}

        logger.debug("Putting joke_id_list in the session: " + joke_id_list.to_s())

        # put the id list in the session
        session[:leanderboard_joke_list] = joke_id_list
      else
        @index = params[:index]
      end

      #otherwise it's pretty simple, just get the joke id list out of the session and use that to get the current joke
      joke_id_list = session[:leaderboard_joke_list]
      if !joke_id_list.nil? 
        joke_id = joke_id_list[@index]

        @joke = Joke.find(:id => joke_id)
      end 
    end
     
     logger.debug "Sort type: " + @sort_type
     generate_title "Leaderboards"
        
    respond_to do |format|
      format.html
      format.mobile
      format.js {render :layout => false}
      format.xml  { render :xml => @jokes }
    end
  end

  def get_joke_list(sort, time)
    sort_direction_text = sort == "bottom" ? "ASC" : "DESC"

    if sort == "newest"
      if is_clean_mode?
        return Joke.select("*").where('is_kid_safe = 1').order("created_at DESC").limit(10)
      else
        return Joke.select("*").order("created_at DESC").limit(10)
      end
    else
      kid_safe_clause = is_clean_mode? ? 'is_kid_safe = 1 AND '  : ""

      case time
      when "today"
         return Joke.where(["#{kid_safe_clause} created_at BETWEEN ? AND ?", Date.today, Date.tomorrow - 1.minute]).order("(up_votes - down_votes) #{sort_direction_text}").limit(10)
      when "week"    
        return Joke.where(["#{kid_safe_clause} created_at BETWEEN ? AND ?", Time.now.beginning_of_week, Time.now]).order("(up_votes - down_votes) #{sort_direction_text}").limit(10)
      when "month"
        return Joke.where(["#{kid_safe_clause} created_at BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now]).order("(up_votes - down_votes) #{sort_direction_text}").limit(10)
      when "all-time"
        if is_clean_mode?
          return Joke.select("*").where('is_kid_safe = 1').order("(up_votes - down_votes) #{sort_direction_text}").limit(10)
        else
          return Joke.select("*").order("(up_votes - down_votes) #{sort_direction_text}").limit(10)
        end
      end
    end

    return nil;
  end
  
end
