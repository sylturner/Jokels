# -*- encoding : utf-8 -*-
class CreateJokes < ActiveRecord::Migration
  def self.up
    create_table :jokes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :jokes
  end
end
