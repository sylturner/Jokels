class FilterExistingSpam < ActiveRecord::Migration
  def up
  	Joke.where("question LIKE '%http://%' OR answer LIKE '%http://%'").destroy_all;
  	AlternatePunchline.where("punchline LIKE '%http://%'").destroy_all;
  end

  def down
  end
end
