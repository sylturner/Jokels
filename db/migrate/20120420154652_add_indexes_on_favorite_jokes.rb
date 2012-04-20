class AddIndexesOnFavoriteJokes < ActiveRecord::Migration
  def self.up
    add_index :favorite_jokes, :user_id
    add_index :favorite_jokes, :joke_id
  end

  def self.down
    remove_index :favorite_jokes, :user_id
    remove_index :favorite_jokes, :joke_id
  end
end
