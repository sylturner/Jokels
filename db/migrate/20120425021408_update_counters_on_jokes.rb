# -*- encoding : utf-8 -*-
class UpdateCountersOnJokes < ActiveRecord::Migration
  def self.up
    Joke.update_all("favorite_jokes_count = 0", "favorite_jokes_count is null")
    Joke.update_all("alternate_punchlines_count = 0", "alternate_punchlines_count is null")

  	change_column :jokes, :alternate_punchlines_count, :integer, :default => 0, :null => false
  	change_column :jokes, :favorite_jokes_count, :integer, :default => 0, :null => false
  end

  def self.down
  	change_column :jokes, :favorite_jokes_count, :integer
  	change_column :jokes, :alternate_punchlines_count, :integer, :default => 0
  end
end
