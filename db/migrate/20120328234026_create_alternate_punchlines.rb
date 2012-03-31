class CreateAlternatePunchlines < ActiveRecord::Migration
  def self.up
    create_table :alternate_punchlines do |t|
      t.integer :joke_id
      t.text :punchline
      t.integer :user_id
      t.integer :up_votes
      t.integer :down_votes

      t.timestamps
    end
  end

  def self.down
    drop_table :alternate_punchlines
  end
end
