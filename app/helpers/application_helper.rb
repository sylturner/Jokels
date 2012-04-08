module ApplicationHelper  
	def anon_user_icon
		# make an array of all the user icons in the directory
		icons = Dir.entries("#{Rails.root}/public/images/user-icons/").delete_if {|i| !i.starts_with? 'user'}		
		# return a random user icon's path for anonymous authors
		return "/images/user-icons/#{icons.sample}"
	end
end
