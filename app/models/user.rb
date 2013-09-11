# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  make_voter

  include Achievements

  has_many :jokes
  has_many :favorite_jokes, :dependent => :destroy
  has_many :alternate_punchlines

  has_many :subscriptions
  has_many :subscribers, :class_name => "User", :through => :subscriptions, :source => :user

  def image
    if self.hide_avatar
      ApplicationController.helpers.anon_user_icon
    else
      self.image_url
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]

      # use their twitter name as their name
      if auth["provider"] == "twitter"
        user.name = auth["info"]["nickname"]
        user.url = auth["info"]["urls"]["Twitter"]
        user.token = auth["credentials"]["token"]
        user.secret = auth["credentials"]["secret"]
        user.image_url = auth["info"]["image"]
      elsif auth["provider"] == "facebook"
        user.name = auth["info"]["name"]
        user.url = auth["info"]["urls"]["Facebook"]
        user.image_url = auth["info"]["image"]
      elsif auth["provider"] == "persona"
        user.name = "Persona User"
        user.url = ""
        user.hide_url = true
        hash = Digest::MD5.hexdigest(auth["uid"])
        user.image_url = "http://www.gravatar.com/avatar/#{hash}?d=retro"
      end
    end
  end

  def self.update_twitter_user_profile_images
    User.where(:provider => "twitter").each do |user|
      begin
        # fetch the twitter user again
        user.update_attribute(:image_url, Twitter.user(user.uid.to_i)[:profile_image_url])
      rescue Twitter::Error::ClientError::NotFound
        # if they're not on twitter anymore, just set it to hide avatar to use our random anon ones
        user.update_attribute(:hide_avatar, true)
      rescue Twitter::Error::ClientError::TooManyRequests => e
        # if we get rate limited, then raise the exception here
        raise e
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

  def favorite_count
    favorite_jokes_count
  end

  def forks_count
    alternate_punchlines_count
  end

  def total_joke_score
    total_score = 0
    jokes.each do |joke|
      total_score += joke.votes
    end

    total_score
  end

  def forked_jokes
    jokes = []
    self.alternate_punchlines.group_by(&:joke_id).each do |ap|
      joke = Joke.find ap[0]
      jokes << joke
    end
    jokes
  end

  def user_name
    if !self.display_name.blank?
      return self.display_name
    elsif self.provider == "twitter" && self.display_name.blank?
      return "@"+self.name
    else
      return self.name
    end
  end
end
