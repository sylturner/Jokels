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

end
