# -*- encoding : utf-8 -*-
class AlternatePunchline < ActiveRecord::Base
	make_voteable

	belongs_to :joke, :counter_cache => true
	belongs_to :user, :counter_cache => true
	  
	attr_reader :auto_post
	attr_writer :auto_post

	def is_profane?
		ProfanityFilter::Base.profane?(self.punchline)
	end
	
end
