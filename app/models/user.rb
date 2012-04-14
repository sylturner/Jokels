class User < ActiveRecord::Base
  make_voter
  
  include Achievements
  
  has_many :jokes
  has_many :favorite_jokes, :dependent => :destroy
  has_many :alternate_punchlines
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      
      user.name = auth["user_info"]["name"]      
      
      # use their twitter name as their name
      if auth["provider"] == "twitter"
        user.name = auth["user_info"]["nickname"]
        user.url = auth["user_info"]["urls"]["Twitter"]        
        user.token = auth["credentials"]["token"]
        user.secret = auth["credentials"]["secret"]
        user.image_url = "https://api.twitter.com/1/users/profile_image?screen_name=#{user.name}&size=normal"
      elsif auth["provider"] == "facebook"
        user.url = auth["user_info"]["urls"]["Facebook"]        
        user.image_url = auth["user_info"]["image"]
      end      
    end
  end

  def self.update_twitter_user_profile_images
    User.where(:provider => "twitter").each do |user|
      user.image_url = "https://api.twitter.com/1/users/profile_image?screen_name=#{user.name}&size=normal"
      user.save
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

  def joke_count
    jokes.count
  end

  def favorite_count
    favorite_jokes.count
  end

  def fork_count
    alternate_punchlines.count
  end

  def total_joke_score
    total_score = 0
    jokes.each do |joke|
      total_score += joke.votes
    end

    total_score
  end
  
end
