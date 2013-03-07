# -*- encoding : utf-8 -*-
class UpdateAlternatePunchlinesCountOnUser < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      User.update_counters user.id, :alternate_punchlines_count => user.alternate_punchlines.length, :favorite_jokes_count => user.favorite_jokes.length, :jokes_count => user.jokes.length
    end
  end

  def self.down
    User.update_all({:alternate_punchlines_count => 0, :favorite_jokes_count => 0, :jokes_count => 0})
  end
end
