// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$('#question-mark').click(function(){$("#why").dialog({modal: true, title: "Why login with Twitter or Facebook?", width: 450});})
	$('#daily-inspiration').qtip({
		style: {
		  classes: 'ui-tooltip-rounded ui-tooltip-shadow',
		  width: "200px"
		},		
		position:{
			my: 'top right',
			at: 'bottom right',
			target: $('#daily-inspiration')
		}		
	});

	enable_joke_qtips();
	enable_user_qtips();
	enrich_leaderboards();
	enable_basic_qtips();
});

function enable_datatable() {
	var oTable = $('#joke_datatable').dataTable({
			"sPaginationType": "full_numbers"
		});

		oTable.$(".ajax-checkbox").click(function() {
			$.ajax({
		    url: $(this).data('href'),
		    type: 'POST',
		    dataType: 'script'
		  });

		  return false;
		});
}

function enable_checkbox() {
	$(".ajax-checkbox").click(function() {
			$.ajax({
		    url: $(this).data('href'),
		    type: 'POST',
		    dataType: 'script'
		  });

		  return false;
		});
}

function enable_basic_qtips()
{
	$(".qtip-capable").each(function() {

		if( $(this).qtip )
      	{
	        $(this).qtip({
	            style: {
	              classes: 'ui-tooltip-rounded ui-tooltip-shadow',
	              width: "200px"
	            },    
	            position:{
	              my: 'bottom right',
	              at: 'top left',
	              target: $(this),
	              viewport: $(window)
	            }   
	          });
      	}
    });
}

function enable_joke_qtips()
{
	$(".qtip-joke").each(function() {
		var id = $(this).attr("data-joke-id");
		var on_joke = $(this).attr("data-on-joke");

		$(this).qtip({
			style: {
				classes: 'ui-tooltip-rounded ui-tooltip-shadow ui-tooltip-dark'
			},
			position:{
				my: (on_joke === "true") ? 'top right' : 'top left',
				at: (on_joke === "true") ? 'bottom left' : 'bottom left',
	            viewport: $(window),
	            effect: false
			},
			content:{
				text: 'Loading joke info...<img src="/images/qtip-ajax-loader.gif"/>',
				ajax: 
					{
						url: '/qtip/joke',
			    		data: { id: id},
			    		method: 'get'
			    	},
			}
		});
	});
}

function enable_user_qtips()
{
	$(".qtip-user").each(function() {
		var id = $(this).attr("data-user-id");
		var include_avatar = $(this).attr("data-include-avatar");
		var main_avatar = $(this).hasClass("avatar");
		$(this).qtip({
			style: {
				classes: 'ui-tooltip-rounded ui-tooltip-shadow ui-tooltip-dark'
			},
			position:{
				my: (main_avatar ? 'top center' : 'top left'),
				at: (main_avatar ? 'bottom center' : 'bottom left'),
	            viewport: $(window),
	            effect: false
			},
			content:{
				text: 'Loading user info...<img src="/images/qtip-ajax-loader.gif"/>',
				ajax: 
					{
						url: '/qtip/user',
			    		data: { id: id, include_avatar: include_avatar},
			    		method: 'get'
			    	},
			}
		});
	});

	 $('.avatar.avatar-anon').qtip({
		style: {
			classes: 'ui-tooltip-rounded ui-tooltip-shadow ui-tooltip-dark'
		},
		position: {  	
			my: 'top center', 	
			at: 'bottom center'	
		}
	});
}

function enrich_leaderboards()
{
	$("#sort_type_radio").buttonset();
  	$("#sort").buttonset();
  	$("#time").buttonset();
  	$("#view").buttonset();

  	$("input:radio").unbind("click");

  	$("input:radio").click(function(){	
  		$("#leaderboard-jokes").slideUp("fast");
      	$("#leaderboard").append('<div id="loading">Loading leaderboard...</div>');
      	$("#loading").delay(1000).fadeIn("slow");

	  	sort_type = $('input:radio[name=sort_type]:checked').val();
	  	sort = $('input:radio[name=sort]:checked').val();
	  	time = $('input:radio[name=time]:checked').val();
	  	view = $('input:radio[name=view]:checked').val();

	  	var refresh_url = "?sort_type="+sort_type+"&sort="+sort+(time ? "&time="+time : "" )+"&view=" + view;
	  	if ( history.pushState )
	  		history.pushState({}, "Leaderboards", refresh_url);

	  	$.ajax({
				  type: "GET",
				  url: refresh_url,
				  dataType: "script"
				});
  	});
}

function showSignInQtip()
{
	$("#signIn").qtip({
		content: "Please login to vote on jokes, save your favorite jokes, get credit for your jokes and more!",
		show: {ready: true, target: $(null)},
		hide: {target: $("#signIn a")},
		position: {my: 'top right', at: 'bottom left', target: $("#signIn"), viewport: $(window)}
	});
}