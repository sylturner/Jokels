module ApplicationHelper  
	def anon_user_icon
		# make an array of all the user icons in the directory
		icons = Dir.entries("#{Rails.root}/public/images/user-icons/").delete_if {|i| !i.starts_with? 'user'}		
		# return a random user icon's path for anonymous authors
		return "/images/user-icons/#{icons.sample}"
	end

	# See http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-different-format-in-rails
	def with_format(format, &block)
	    old_formats = formats
	    self.formats = [format]
	    block.call
	    self.formats = old_formats
	    nil
  	end

  	def nvl(value, default)
  		logger.debug "Value: #{value}"
  		logger.debug "Default: #{default}"
  		return default if value.nil?

  		return value
  	end
end
