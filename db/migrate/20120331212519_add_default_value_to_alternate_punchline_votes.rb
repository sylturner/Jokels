class AddDefaultValueToAlternatePunchlineVotes < ActiveRecord::Migration
  def self.up  	
  	change_column_default :alternate_punchlines, :up_votes, 0
  	change_column_default :alternate_punchlines, :down_votes, 0
  end

  def self.down
  	change_column_default :alternate_punchlines, :up_votes, nil
  	change_column_default :alternate_punchlines, :down_votes, nil
  end
end
