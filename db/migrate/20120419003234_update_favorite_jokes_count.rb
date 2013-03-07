# -*- encoding : utf-8 -*-
class UpdateFavoriteJokesCount < ActiveRecord::Migration
  def self.up
    Joke.all.each do |joke|
      Joke.update_counters joke.id, :favorite_jokes_count => joke.favorite_jokes.length
    end
  end

  def self.down
    Joke.update_all(:favorite_jokes_count => 0)
  end
end
