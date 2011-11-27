class Joke < ActiveRecord::Base
  make_voteable

  has_many :categories
  
  belongs_to :user
  
  validates_presence_of :question, :answer
  
  attr_reader :auto_tweet
  attr_writer :auto_tweet
  
  def self.jokeler_update
    require 'rss/2.0'
    # scan the jokeler's RSS for new jokeler posts and associate them with jokes
    source = "http://jokeler.tumblr.com/rss"
    content = ""
    open(source) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)
    rss = rss.items.delete_if{|x| !x.title.starts_with? "http://"}
    rss.each do |x| 
      id = x.title.split('/').last
      joke = Joke.find(id)
      if !joke.jokeler_url
        joke.jokeler_url = x.link      
        joke.save!
      end
    end
  end
  
  # add bitly urls to jokes that don't have them (more of a fixerupper)
  # limit to 10 by default so we don't overload bit.ly API request limits
  def self.add_bitly_urls(count = 10)
    Joke.where(:bitly_url => nil).limit(count).each do |joke|
      joke.generate_bitly_url
    end
  end
  
  def generate_bitly_url
    bitly = Bitly.client
    response = bitly.shorten("http://jokels.com/jokes/#{self.id}")
    self.bitly_url = response.short_url
    self.save!
  end
  
  # tweet yetserday's top joke
  # def self.tweet_top_joke
  #    top_joke = Joke.where(['created_at BETWEEN ? AND ?', Date.yesterday, Time.now]).sort_by{|x| x.votes}.reverse[0]
  #    if top_joke
  #      tweet = "Yesterday's top joke: #{top_joke.question}"
  #      
  #      user = top_joke.user
  #      if user
  # 
  #      end
  #      
  #    end
  #  end
  
end
