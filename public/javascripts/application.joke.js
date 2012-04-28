$(document).ready(function() {
	$('#click-for-punchline, #question').click(enable_joke_stuff);
});

function enable_joke_stuff()
{	
	$('#click-for-punchline').hide();
	$('#answer-container').slideDown('fast');
	$('#question').css('cursor', 'default');
	$("#share").delay(750).slideDown('fast');
	$('#refresh-joke').delay(750).slideDown('fast');
	$('#alternate-punchlines-button').delay(750).slideDown('fast');
	$('.up_arrow').hover(
		function(){$(this).attr("src","/images/arrow_up.png")}, 
		function(){$(this).attr("src", $(this).attr("data-orig-src"))});
	$('.down_arrow').hover(
		function(){$(this).attr("src","/images/arrow_down.png")}, 
		function(){$(this).attr("src", $(this).attr("data-orig-src"))});
	$('#show-original').click(function(){
		$("#answer-container").slideDown("fast");
		$("#share").slideDown("fast");
		$(this).slideUp("fast");
	})
}