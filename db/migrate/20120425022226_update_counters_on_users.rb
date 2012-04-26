class UpdateCountersOnUsers < ActiveRecord::Migration
  def self.up

    User.update_all("alternate_punchlines_count = 0", "alternate_punchlines_count is null")
    User.update_all("favorite_jokes_count = 0", "favorite_jokes_count is null")
    User.update_all("jokes_count = 0", "jokes_count is null")

  	change_column :users, :alternate_punchlines_count, :integer, :default => 0, :null => false
    change_column :users, :favorite_jokes_count, :integer, :default => 0, :null => false
    change_column :users, :jokes_count, :integer, :default => 0, :null => false
  end

  def self.down
  	change_column :users, :alternate_punchlines_count, :integer
    change_column :users, :favorite_jokes_count, :integer
    change_column :users, :jokes_count, :integer
  end
end
