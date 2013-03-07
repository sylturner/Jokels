# -*- encoding : utf-8 -*-
module LeaderboardHelper

	def generate_leaderboard_link time, sort, sort_type
		return "/leaderboard/#{time}/#{sort}/#{sort_type}"
	end

	def leaderboard_sorting_button time, sort, sort_type, link_text, condition
		css_class = "ui-btn-active" if condition
		link_to link_text, generate_leaderboard_link(time,sort,sort_type), "data-role" => "button", "data-mini" => "true", :class => css_class
	end

	def leaderboard_radio_buttons option_set, selected_option, option_type
		result = ""
		option_set.each do |current_option|
			result += radio_button_tag option_type, current_option, (current_option == selected_option)
			result += label_tag "#{option_type}_#{current_option}", current_option.sub(/-/, " ").humanize.capitalize
		end
		
		return result.html_safe
	end
end
