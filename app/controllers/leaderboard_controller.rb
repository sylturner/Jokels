class LeaderboardController < ApplicationController

  def index 
     #sorting from highest to lowest for the past week is the default behavior    
     @time = params[:time] || "week"
     @type = params[:type] || "jokes"
     @sort = params[:sort] || "top"
     @user_opts = params[:user_opts] || "most"
     if @type == "jokes"
      sort_direction = @sort == "top" ? 1 : -1
       
      case @time
      when "today"
         @jokes = Joke.where(['created_at BETWEEN ? AND ?', Date.today, Date.tomorrow - 1.minute]).sort_by{|x| (sort_direction*x.votes)}.reverse[0...10]
      when "week"    
        @jokes = Joke.where(['created_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now]).sort_by{|x| (sort_direction*x.votes)}.reverse[0...10]
      when "month"
        @jokes = Joke.where(['created_at BETWEEN ? AND ?', Time.now.beginning_of_month, Time.now]).sort_by{|x| (sort_direction*x.votes)}.reverse[0...10]
      when "all-time"
        @jokes = Joke.all.sort_by{|x| (sort_direction*x.votes)}.reverse[0...10]
      when "newest"
        @jokes = Joke.all.reverse[0...10]
     end
     elsif @type == "users"
       case @user_opts
       when "most"
         @users = User.all.sort_by{|u| u.jokes.size}.reverse
       when "best-week"
         # user with most best vote total for jokes written this week
       end
        
     end
     
     generate_title "Leaderboards"
        
    respond_to do |format|
      format.html
      format.xml  { render :xml => @jokes }
    end
  end

  def highest_rated
    @jokes = Joke.all.sort_by{|joke| joke.votes}.reverse[0...25]
    respond_to do |format|
      format.html
      format.xml  { render :xml => @jokes }
    end
  end
  
  def lowest_rated
    @jokes = Joke.all.sort_by{|joke| joke.votes}[0...25]
    respond_to do |format|
      format.html
      format.xml  { render :xml => @jokes }
    end
  end
    
  
  def rated (order = "highest", time = "week")
    case time
    when "week"
    when "day"
    when "all" 
      @jokes = Joke.all.sort_by{|joke| joke.votes}.reverse[0...10]
    end
    
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @jokes }
    end
  end
  
end
