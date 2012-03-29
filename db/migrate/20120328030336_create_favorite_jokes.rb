class CreateFavoriteJokes < ActiveRecord::Migration
  def self.up
    create_table :favorite_jokes do |t|
      t.integer :user_id
      t.integer :joke_id

      t.timestamps
    end
  end

  def self.down
    drop_table :favorite_jokes
  end
end
