$(document).ready(function() {
	$('#click-for-punchline, #question').click(enable_joke_stuff);
	$('.alternate-punchline-embed').click(function() {execute_alt_punchline($(this).data("url"));});
});

function enable_joke_stuff()
{	
	var jokeId = $(this).data("joke-id");
	var containerSelector = '#joke-container[data-joke-id="' + jokeId + '"] ';

	$(containerSelector + '#click-for-punchline').hide();
	$(containerSelector + '#answer-container').slideDown('fast');
	$(containerSelector + '#question').css('cursor', 'default');
	$(containerSelector + "#share").delay(750).slideDown('fast');
	$(containerSelector + '#refresh-joke').delay(750).slideDown('fast');
	$(containerSelector + '#alternate-punchlines-button').delay(750).slideDown('fast');
	$(containerSelector + '.up_arrow').hover(
		function(){$(this).attr("src","/images/arrow_up.png")}, 
		function(){$(this).attr("src", $(this).attr("data-orig-src"))});
	$(containerSelector + '.down_arrow').hover(
		function(){$(this).attr("src","/images/arrow_down.png")}, 
		function(){$(this).attr("src", $(this).attr("data-orig-src"))});
	$(containerSelector + '#show-original').click(function(){
		$("#answer-container").slideDown("fast");
		$("#share").slideDown("fast");
		$(this).slideUp("fast");
	})
}

function execute_alt_punchline(url)
{
	if ( url )
	{
		$.ajax({
			type: "GET",
			dataType: "script",
			url: url
		});
	}
}