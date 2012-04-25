class AddHitCounterToJoke < ActiveRecord::Migration
  def self.up
    add_column :jokes, :hit_counter, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :jokes, :hit_counter
  end
end
