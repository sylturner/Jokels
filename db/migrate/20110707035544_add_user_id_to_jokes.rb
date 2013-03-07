# -*- encoding : utf-8 -*-
class AddUserIdToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :user_id, :integer
  end

  def self.down
    remove_column :jokes, :user_id
  end
end
