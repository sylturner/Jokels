class FavoriteJoke < ActiveRecord::Base
  belongs_to :joke, :counter_cache => true
  belongs_to :user, :counter_cache => true
end
