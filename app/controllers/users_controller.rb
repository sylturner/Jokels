class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

    @jokes = Joke.find_all_by_user_id(params[:id])
    @jokes = @jokes.select{|joke| joke.is_kid_safe} if is_clean_mode?

    @favorite_jokes = @user.favorite_jokes
    @favorite_jokes = @favorite_jokes.select{|fav_joke| fav_joke.joke.is_kid_safe} if is_clean_mode?

    @forked_jokes = @user.forked_jokes
    @forked_jokes = @forked_jokes.select{|forked_joke| forked_joke.is_kid_safe} if is_clean_mode?
    
    generate_title "#{user_name @user}'s jokes"
    
    respond_to do |format|
      format.html
    end
  end
  
  def qtip
    @user = User.find(params[:id])
    generate_title user_name(@user)

    @include_avatar = (params[:include_avatar] == "true")

    respond_to do |format|
      format.html {render :layout => false} #qtip.html.erb
    end
  end

  def feed
    @user = User.find(params[:id])
    @type = params[:type]
    @index = params[:index]

    @type ||= "authored"
    @index ||= 0

    is_clean_clause = is_clean_mode? == 1 ? " AND is_kid_safe = 1" : ""
    if @type == "authored"
      generate_subtitle (user_name(@user) + "'s Jokes")
      
      @limit = Joke.count(:conditions => "user_id = #{@user.id} #{is_clean_clause}");

      @index = generate_index(@index, @limit)

      if index_test(@index, @limit)
        return
      end

      @joke = Joke.where(["user_id = ? #{is_clean_clause}", @user.id]).order("created_at ASC").limit(1).offset(@index)[0]
    elsif @type == "favorite_jokes"
      generate_subtitle (user_name(@user) + "'s Favorite Jokes")
      @limit = FavoriteJoke.joins(:joke).count(:conditions => "favorite_jokes.user_id = #{@user.id} #{is_clean_clause}")

      @index = generate_index(@index, @limit)

      if index_test(@index, @limit)
        return
      end

      @joke = FavoriteJoke.joins(:joke).where(["favorite_jokes.user_id = ? #{is_clean_clause}", @user.id]).order("created_at ASC").limit(1).offset(@index)[0].joke
    else
      generate_subtitle (user_name(@user) + "'s Forked Jokes")
      is_clean_clause = is_clean_mode? == 1 ? " AND alternate_punchlines.is_kid_safe = 1 AND jokes.is_kid_safe = 1" : ""
      @limit = AlternatePunchline.joins(:joke).count(:conditions => "alternate_punchlines.user_id = #{@user.id} #{is_clean_clause}");

      @index = generate_index(@index, @limit)

      if index_test(@index, @limit)
        return
      end

      @joke = AlternatePunchline.joins(:joke).where(["alternate_punchlines.user_id = ? #{is_clean_clause}", @user.id]).order("created_at ASC").limit(1).offset(@index)[0].joke
    end

    respond_to do |format|
      format.html 
      format.js 
    end
  end

  
end
