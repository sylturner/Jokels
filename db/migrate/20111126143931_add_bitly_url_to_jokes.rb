# -*- encoding : utf-8 -*-
class AddBitlyUrlToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :bitly_url, :string
  end

  def self.down
    remove_column :jokes, :bitly_url
  end
end
