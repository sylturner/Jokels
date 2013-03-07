# -*- encoding : utf-8 -*-
class UpdateAlternatePunchlinesCount < ActiveRecord::Migration
  def self.up
    Joke.all.each do |joke|
      Joke.update_counters joke.id, :alternate_punchlines_count => joke.alternate_punchlines.length
    end
  end

  def self.down
    Joke.update_all(:alternate_punchlines_count => 0)
  end
end
