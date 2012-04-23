class AdminController < ApplicationController
	before_filter :admin_check

	def joke_management
		@jokes = Joke.all
		@title = "Joke Administration"

		respond_to do |format|
	      format.html # show.html.erb
	    end
	end

	def index
		@title = "Jokels Administration"
	end

	def admin_check
		if current_user.nil? 
			respond_to do |format|
				format.html {redirect_to(root_url, :notice => 'Please login to access the administration area.') }
			end
		elsif !current_user.is_admin
			respond_to do |format|
				format.html {redirect_to(root_url, :notice => 'Please login to access the administration area.') }
			end
		end
	end
end
