# -*- encoding : utf-8 -*-
class AlternatePunchline < ActiveRecord::Base
	make_voteable
	#span filtering
	filters_spam({
	:message_field => :punchline,
	:email_field => :punchline,
	:author_field => :punchline,
	:other_fields => [],
	:extra_spam_words => %w()
	})

  validate :spam_check

	belongs_to :joke, :counter_cache => true
	belongs_to :user, :counter_cache => true

	validates_presence_of :punchline

	attr_reader :auto_post
	attr_writer :auto_post

	def is_profane?
		ProfanityFilter::Base.profane?(self.punchline)
	end

  def spam_check
    if self.spam
      self.errors[:base] << "This is probably spam."
    end
  end
	
end
