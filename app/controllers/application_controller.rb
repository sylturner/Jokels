class ApplicationController < ActionController::Base
  protect_from_forgery
  has_mobile_fu
  
  before_filter :is_mobile
  
  helper_method :current_user
  helper_method :daily_word
  helper_method :generate_title
  helper_method :user_name

  DEFAULT_TITLE = "Jokels - Share your jokes!"

  private

  def current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def daily_word
    @daily_word = DailyWord.last[:word] if DailyWord.last
  end
  
  def generate_title text = nil
    if text
      @title = "Jokels - #{text} - Share your jokes!"
      @meta_description = "#{text}"
    else
      @title = DEFAULT_TITLE
      @meta_description = "Jokels is a fun place to write jokes and share them with your friends!"
    end
  end
  
  # puts an @ in front of Twitter names  
  def user_name user
    if user.provider == "twitter"
      return "@"+user.name
    else
      return user.name
    end
  end
  
  def is_mobile
    if session[:mobile_view].nil? || session[:mobile_view]
      request.format = :mobile if is_mobile_device?
    else
      request.format = :html
    end
  end
  
end
