class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @jokes = Joke.find_all_by_user_id params[:id]
    respond_to do |format|
      format.html
    end
  end
  
end
