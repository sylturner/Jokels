class Joke < ActiveRecord::Base
  make_voteable

  has_many :categories
  
  belongs_to :user
  
  validates_presence_of :question, :answer
  
  attr_reader :auto_tweet
  attr_writer :auto_tweet
  
end
