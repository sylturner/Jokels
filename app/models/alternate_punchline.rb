class AlternatePunchline < ActiveRecord::Base
	make_voteable

	belongs_to :joke
	belongs_to :user
	
end
