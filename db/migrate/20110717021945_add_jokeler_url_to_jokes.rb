class AddJokelerUrlToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :jokeler_url, :string
  end

  def self.down
    remove_column :jokes, :jokeler_url
  end
end
