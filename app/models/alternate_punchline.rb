class AlternatePunchline < ActiveRecord::Base
	make_voteable

	belongs_to :joke, :counter_cache => true
	belongs_to :user, :counter_cache => true

	def is_profane?
		ProfanityFilter::Base.profane?(self.punchline)
	end
	
end
