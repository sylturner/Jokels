// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$('#click-for-punchline, #question').click(enable_joke_stuff);
});

function enable_joke_stuff()
{
	$('#click-for-punchline').hide();
	$('#answer').slideDown('fast');
	$('#question').css('cursor', 'default');
	$('#refresh-joke').delay(1000).slideDown();
}