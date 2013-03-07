# -*- encoding : utf-8 -*-
class CreateDailyWords < ActiveRecord::Migration
  def self.up
    create_table :daily_words do |t|
      t.string :word

      t.timestamps
    end
  end

  def self.down
    drop_table :daily_words
  end
end
