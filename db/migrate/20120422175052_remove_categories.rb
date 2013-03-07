# -*- encoding : utf-8 -*-
class RemoveCategories < ActiveRecord::Migration
  def self.up
    drop_table :categories
  end

  def self.down
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
