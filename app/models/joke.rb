class Joke < ActiveRecord::Base
  
  has_many :categories
  
  belongs_to :user
  
  validates_presence_of :question, :answer
  
end
