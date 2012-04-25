class UpdateCountersOnJokes < ActiveRecord::Migration
  def self.up
  	Joke.all.each do |joke|
  		joke.favorite_jokes_count ||= 0
  		joke.alternate_punchlines_count ||= 0
  		joke.save()
  	end 

  	change_column :jokes, :alternate_punchlines_count, :integer, :default => 0, :null => false
  	change_column :jokes, :favorite_jokes_count, :integer, :default => 0, :null => false
  end

  def self.down
  	change_column :jokes, :favorite_jokes_count, :integer
  	change_column :jokes, :alternate_punchlines_count, :integer, :default => 0
  end
end
