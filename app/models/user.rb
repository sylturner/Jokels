class User < ActiveRecord::Base
  make_voter
  
  include Achievements
  
  has_many :jokes
  has_many :favorite_jokes, :dependent => :destroy
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      
      user.name = auth["user_info"]["name"]
      user.image_url = auth["user_info"]["image"]
      
      # use their twitter name as their name
      if auth["provider"] == "twitter"
        user.name = auth["user_info"]["nickname"]
        user.url = auth["user_info"]["urls"]["Twitter"]        
        user.token = auth["credentials"]["token"]
        user.secret = auth["credentials"]["secret"]
      elsif auth["provider"] == "facebook"
        user.url = auth["user_info"]["urls"]["Facebook"]        
      end      
    end
  end
  
  def favorited?(joke)
    logger.debug "Joke empty? " + (favorite_jokes.where(:joke_id => joke.id).empty? ? "true" : "false")
    logger.debug "Joke size: #{favorite_jokes.where(:joke_id => joke.id).size} "
    
    if favorite_jokes.where(:joke_id => joke.id).empty?
      false
    else
      true
    end
  end
  
  def toggle_favorite(joke)
    if favorite_jokes.where(:joke_id => joke.id).empty?
      favorite_jokes.build(:joke_id => joke.id).save
    else
      favorite_jokes.where(:joke_id => joke.id).delete_all
    end
  end
  
end
