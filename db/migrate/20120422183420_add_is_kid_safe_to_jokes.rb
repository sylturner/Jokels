class AddIsKidSafeToJokes < ActiveRecord::Migration
  def self.up
    add_column :jokes, :is_kid_safe, :boolean

    Joke.all.each do |joke|
      joke.is_kid_safe = !(ProfanityFilter::Base.profane?(joke.question) || ProfanityFilter::Base.profane?(joke.answer))
      joke.save();
    end
  end

  def self.down
    remove_column :jokes, :is_kid_safe
  end
end
