// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$('#click-for-punchline, #question').click(function(){$('#click-for-punchline').hide();$('#answer').slideDown('fast');})
});