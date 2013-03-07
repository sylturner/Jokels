# -*- encoding : utf-8 -*-
class AddQuestionToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :question, :string
  end

  def self.down
    remove_column :jokes, :question
  end
end
