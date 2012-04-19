class AddAlternatePunchlinesCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :alternate_punchlines_count, :integer
    add_column :users, :favorite_jokes_count, :integer
    add_column :users, :jokes_count, :integer
  end

  def self.down
    remove_column :users, :alternate_punchlines_count
    remove_column :users, :favorite_jokes_count
    remove_column :users, :jokes_count
  end
end
