# -*- encoding : utf-8 -*-
module JokesHelper
	class JokeSpamValidator < ActiveModel::Validator
	   def validate(record)
	    if record.spam
	      record.errors[:base] << "We think this joke is probably spam."
	    end
	  end
	end
end
