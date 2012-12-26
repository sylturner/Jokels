module ApplicationHelper
	def anon_user_icon
		# make an array of all the user icons in the directory
		icons = Dir.entries("#{Rails.root}/app/assets/images/user-icons/").delete_if {|i| !i.starts_with? 'user'}		
		# return a random user icon's path for anonymous authors
		return "/assets/user-icons/#{icons.sample}"
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

  # send this helper method the joke.tag_list and make the links to the categories pages
  def tag_links(tags)
    output = ""
    tags.each do |tag|
      output += "<a href=\"/tags/#{CGI.escape(tag)}\">#{tag}</a><br/>"
    end
    return output
  end

end
