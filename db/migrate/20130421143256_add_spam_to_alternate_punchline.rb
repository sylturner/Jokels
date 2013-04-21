class AddSpamToAlternatePunchline < ActiveRecord::Migration
  def change
    add_column :alternate_punchlines, :spam, :boolean
  end
end
