class Joke < ActiveRecord::Base
  has_many :categories
  
  validates_presence_of :question, :answer
  
end
