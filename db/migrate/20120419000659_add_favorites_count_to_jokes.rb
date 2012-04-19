class AddFavoritesCountToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :favorite_jokes_count, :integer
  end

  def self.down
    remove_column :jokes, :favorite_jokes_count
  end
end
