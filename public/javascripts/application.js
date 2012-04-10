// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$('#click-for-punchline, #question').click(enable_joke_stuff);
	$('#question-mark').click(function(){$("#why").dialog({modal: true, title: "Why login with Twitter or Facebook?", width: 450});})
	$('#daily-inspiration').qtip({
		style: {
		  classes: 'ui-tooltip-rounded ui-tooltip-shadow'
		},		
		position:{
			my: 'top right',
			at: 'bottom right',
			target: $('#daily-inspiration')
		}		
	});
});

function enable_joke_stuff()
{	
	$('#click-for-punchline').hide();
	$('#answer').slideDown('fast');
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
		$("#answer").slideDown("fast");
		$("#share").slideDown("fast");
		$(this).slideUp("fast");
	})
}

function enrich_leaderboards()
{
	$("#sort_type_radio").buttonset();
  	$("#sort").buttonset();
  	$("#time").buttonset();

  	$("input:radio").unbind("click");

  	$("input:radio").click(function(){	
	  	sort_type = $('input:radio[name=sort_type]:checked').val();
	  	sort = $('input:radio[name=sort]:checked').val();
	  	time = $('input:radio[name=time]:checked').val();

	  	var refresh_url = "?sort_type="+sort_type+"&sort="+sort+(time ? "&time="+time : "" );
	  	if ( history.pushState )
	  		history.pushState({}, "Leaderboards", refresh_url);

	  	$.ajax({
				  type: "GET",
				  url: refresh_url,
				  dataType: "script"
				});
  	});
}