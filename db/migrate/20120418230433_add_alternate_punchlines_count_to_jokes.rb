# -*- encoding : utf-8 -*-
class AddAlternatePunchlinesCountToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :alternate_punchlines_count, :integer, :default => 0
  end

  def self.down
    remove_column :jokes, :alternate_punchlines_count
  end
end
