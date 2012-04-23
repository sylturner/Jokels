class AddIsAdminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_admin, :boolean

    admins = ["Adam Griffis", "adamgriffis", "jokelscom", "JokelsBot", "sylturner", "Syl Turner"]

    User.all.each do |user|
    	user.is_admin = admins.include?(user.name)
    	user.save
    end
  end

  def self.down
    remove_column :users, :is_admin
  end
end
