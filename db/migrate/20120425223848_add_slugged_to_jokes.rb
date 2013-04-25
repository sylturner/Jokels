# -*- encoding : utf-8 -*-
class AddSluggedToJokes < ActiveRecord::Migration
  def self.up
    # add_column :jokes, :slug, :string

    # Joke.all.each do |joke|
    # 	#generate the slug
    # 	joke.save
    # end

    change_column :jokes, :slug, :string, :null => false
    #add_index :jokes, :slug, :unique => true
  end

  def self.down
    remove_column :jokes, :slug
  end
end
