class AddSluggedToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :slug, :String

    Joke.all.each do |joke|
    	#generate the slug
    	joke.save
    end

    change_column :jokes, :slug, :String, :null => false
    add_index :jokes, :slug, :unique => true
  end

  def self.down
    remove_column :jokes, :slug
    #remove_index :jokes, :slug
  end
end
