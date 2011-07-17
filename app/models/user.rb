class User < ActiveRecord::Base
  make_voter
  
  include Achievements
  
  has_many :jokes
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      
      user.name = auth["user_info"]["name"]
      user.image_url = auth["user_info"]["image"]
      
      # use their twitter name as their name
      if auth["provider"] == "twitter"
        #use the @name for twitter accounts. it's more trendy
        user.name = auth["user_info"]["nickname"]
        user.url = auth["user_info"]["urls"]["Twitter"]        
        user.token = auth["credentials"]["token"]
        user.secret = auth["credentials"]["secret"]
      elsif auth["provider"] == "facebook"
        user.url = auth["user_info"]["urls"]["Facebook"]        
      end      
    end
  end
  
end
