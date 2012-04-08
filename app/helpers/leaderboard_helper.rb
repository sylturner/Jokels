module LeaderboardHelper

	def generate_leaderboard_link time, sort, sort_type
		return "/leaderboard/#{time}/#{sort}/#{sort_type}"
	end

	def leaderboard_sorting_button time, sort, sort_type, link_text, condition
		css_class = "ui-btn-active" if condition
		link_to link_text, generate_leaderboard_link(time,sort,sort_type), "data-role" => "button", "data-mini" => "true", :class => css_class
	end
end
