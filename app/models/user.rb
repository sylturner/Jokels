class User < ActiveRecord::Base
  
  has_many :jokes
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      
      # use their twitter name as their name
      if auth["provider"] == "twitter"
        user.name = auth["user_info"]["nickname"]
        user.url = auth["user_info"]["urls"]["Twitter"]        
      else
        user.name = auth["user_info"]["name"]
      end
      
      user.image_url = auth["user_info"]["image"]
    end
  end  
end
