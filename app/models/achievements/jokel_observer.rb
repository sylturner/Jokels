# -*- encoding : utf-8 -*-
class JokelObserver < ActiveRecord::Observer
  observe :user
  
  def after_save(user)
    Jokel.award_achievements_for(user.achievable) if ('your conditions here')
  end
end
