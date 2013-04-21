class AddSpamToJokes < ActiveRecord::Migration
  def change
    add_column :jokes, :spam, :boolean
  end
end
