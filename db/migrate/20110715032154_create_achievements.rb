class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.string  :type
      t.integer :level
      t.integer :achievable_id
      t.string  :achievable_type
      t.integer :ref_id
      t.string  :ref_type

      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end
