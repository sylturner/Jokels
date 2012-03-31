class AddABunchOfIndexes < ActiveRecord::Migration
  def self.up
  	add_index :jokes, :user_id
  	add_index :jokes, :up_votes
  	add_index :jokes, :down_votes

  	add_index :users, :uid

  	add_index :alternate_punchlines, :joke_id
  	add_index :alternate_punchlines, :user_id
  	add_index :alternate_punchlines, :up_votes
  	add_index :alternate_punchlines, :down_votes
  end

  def self.down
	remove_index :jokes, :user_id
  	remove_index :jokes, :up_votes
  	remove_index :jokes, :down_votes

  	remove_index :users, :uid

  	remove_index :alternate_punchlines, :joke_id
  	remove_index :alternate_punchlines, :user_id
  	remove_index :alternate_punchlines, :up_votes
  	remove_index :alternate_punchlines, :down_votes
  end
end
