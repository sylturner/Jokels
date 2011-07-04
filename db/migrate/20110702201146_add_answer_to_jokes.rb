class AddAnswerToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :answer, :string
  end

  def self.down
    remove_column :jokes, :answer
  end
end
