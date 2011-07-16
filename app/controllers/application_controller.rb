class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :daily_word

  private

  def current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def daily_word
    @daily_word = DailyWord.last[:word] if DailyWord.last
  end
end
