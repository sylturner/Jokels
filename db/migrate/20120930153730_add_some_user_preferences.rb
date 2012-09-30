class AddSomeUserPreferences < ActiveRecord::Migration
  def self.up
    add_column :users, :hide_avatar, :boolean, :default => false
    add_column :users, :hide_url, :boolean, :default => false
    add_column :users, :display_name, :string
  end

  def self.down
    remove_column :users, :hide_avatar
    remove_column :users, :hide_url
    remove_column :users, :display_name
  end
end
