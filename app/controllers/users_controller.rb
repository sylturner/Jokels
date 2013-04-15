# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  # set the @user variable
  before_filter :attach_user, :only => [:show, :edit, :feed, :qtip, :update]

  def attach_user
    @user = User.find(params[:id])
  end

  def show
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

  def edit
    redirect_to(@user, :notice => "You can't edit this user, because you aren't this user!") unless @user == current_user
    generate_title "Editing #{user_name @user}"
    # use the user_name helper method to fill in the display name on profile form load 
    @user.display_name = user_name(@user) if @user.display_name.nil?
  end

  def update
    respond_to do |format|
      params[:user].delete :is_admin
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def qtip
    generate_title user_name(@user)

    @include_avatar = (params[:include_avatar] == "true")

    respond_to do |format|
      format.html {render :layout => false} #qtip.html.erb
    end
  end

  def feed
    @type = params[:type]
    @index = params[:index]

    @type ||= "authored"
    @index ||= 0

    is_clean_clause = is_clean_mode? == 1 ? " AND is_kid_safe = 1" : ""
    if @type == "authored"
      generate_subtitle (user_name(@user) + "'s Jokes")

      @limit = Joke.count(:conditions => "user_id = #{@user.id} #{is_clean_clause}");

      return if limit_test(@limit, "#{user_name(@user)} hasn't written any jokes.")

      @index = generate_index(@index, @limit)

      if index_test(@index, @limit)
        return
      end

      @joke = Joke.where(["user_id = ? #{is_clean_clause}", @user.id]).order("created_at ASC").limit(1).offset(@index)[0]
    elsif @type == "favorite_jokes"
      generate_subtitle (user_name(@user) + "'s Favorite Jokes")
      @limit = FavoriteJoke.joins(:joke).count(:conditions => "favorite_jokes.user_id = #{@user.id} #{is_clean_clause}")

      return if limit_test(@limit, "#{user_name(@user)} doesn't have any favorite jokes.")

      @index = generate_index(@index, @limit)

      if index_test(@index, @limit)
        return
      end

      @joke = FavoriteJoke.joins(:joke).where(["favorite_jokes.user_id = ? #{is_clean_clause}", @user.id]).order("created_at ASC").limit(1).offset(@index)[0].joke
    else
      generate_subtitle (user_name(@user) + "'s Forked Jokes")
      is_clean_clause = is_clean_mode? == 1 ? " AND alternate_punchlines.is_kid_safe = 1 AND jokes.is_kid_safe = 1" : ""
      @limit = AlternatePunchline.joins(:joke).count(:conditions => "alternate_punchlines.user_id = #{@user.id} #{is_clean_clause}");

      return if limit_test(@limit, "#{user_name(@user)} doesn't have any forked jokes.")

      @index = generate_index(@index, @limit)

      if index_test(@index, @limit)
        return
      end

      @joke = AlternatePunchline.joins(:joke).where(["alternate_punchlines.user_id = ? #{is_clean_clause}", @user.id]).order("created_at ASC").limit(1).offset(@index)[0].joke
    end

    @sequence_identifier = "user_" + @type;

    respond_to do |format|
      format.html {render :layout => false}
      format.js {render :layout => false}
    end
  end

  def limit_test(limit, message)
    if @limit <= 0
        @no_jokes_message = message
        #no results for this type? just return and let the view handle it
        respond_to do |format|
          format.html {render :layout => false}
        end

        return true
    end

    return false
  end
end
