# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  has_mobile_fu

  before_filter :is_mobile

  helper_method :current_user
  helper_method :daily_word
  helper_method :generate_title
  helper_method :user_name
  helper_method :is_clean_mode?

  DEFAULT_TITLE = "Jokels - Share your jokes!"

  private

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue => e
      @current_user = nil
    end
  end

  def is_clean_mode?
    !session[:clean_mode].nil? && session[:clean_mode]
  end 

  def set_clean_mode value
    session[:clean_mode] = value
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

  def generate_subtitle text = nil
    @subtitle = text 
    generate_title text
  end

  def index_test(index, limit)
    logger.debug("Index test. index #{index}   limit: #{limit}")
    if ( index < 0|| index >= limit)
      logger.debug ("Redirecting to #{user_path(@user)}")
      redirect_to(user_path(@user), :notice => "Sorry! That joke cannot be found")
      return true
    end

    return false
  end

  # if the index is the string "random" it generates a random number using the limit
  def generate_index(index, limit)
    if index == "random"
      index = rand(limit)
    end

    index.to_i()
  end

  # puts an @ in front of Twitter names  
  def user_name user
    if user.nil?
      return nil
    elsif !user.display_name.nil?
      return user.display_name
    elsif user.provider == "twitter" && user.display_name.nil?
      return "@"+user.name
    else
      return user.name
    end
  end

  def is_mobile
    logger.debug "in is_mobile"
    logger.debug "is_mobile format: " + request.format

    if (session[:mobile_view].nil? || session[:mobile_view]) && request.format != "text/javascript"
      request.format = :mobile if is_mobile_device?
    elsif request.format == "text/javascript"
      request.format = :js
    else
      request.format = :html
    end
  end

end
