class UpdateCountersOnUsers < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      user.alternate_punchlines_count ||= 0
      user.favorite_jokes_count ||= 0
      user.jokes_count ||= 0
      user.save()
    end

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
