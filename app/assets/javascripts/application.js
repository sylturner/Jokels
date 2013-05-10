//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree ../../../vendor/assets/javascripts/.
//= require_self
//= require_directory .

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
	fartscroll();
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

		oTable.$(".reassignLink").click(function(){
			var selectBox = $(this).closest("td").find(".reassignSelect");

			selectBox.show();
			selectBox.change(function(){
				var user_id = $(this).val();
				var link = $(this).closest("tr").find("td.deleteLink a").attr("href");
				var reassignUrl = link + "/reassign?user_id=" + user_id;

				$.ajax({
					url: reassignUrl,
					dataType: "script",
					type: "GET"
				})
			});

			$(this).hide();
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
        text: 'Loading joke info...<img src="/assets/qtip-ajax-loader.gif"/>',
        ajax:{
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
				text: 'Loading user info...<img src="/assets/qtip-ajax-loader.gif"/>',
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

function pausecomp(ms) {
	ms += new Date().getTime();
	while (new Date() < ms){}
} 

function clickAltPunchlines(delayTime)
{
	$("#alternate-punchlines-button a").trigger("click");

	setTimeout("clickNextJoke()", delayTime);
}

function clickNextJoke()
{
	$("#refresh-joke a").trigger("click");
}

function clickPunchline()
{
	var delayTime = getDelayTime();

	$("#click-for-punchline").trigger("click");

	if ( $("#alternate-punchlines-button").length > 0 )
		setTimeout("clickAltPunchlines(" + delayTime + ")", delayTime);
	else
		setTimeout("clickNextJoke()", delayTime);
}

function kioskModeStart()
{
	$("#click-for-punchline").livequery(function(){
		var delayTime = getDelayTime();

		setTimeout("clickPunchline()", delayTime);
	});
}

function getDelayTime()
{
	return $("#kiosk_delay_slider").slider("option","value");
}

function fullScreen()
{
	$("#header").addClass("hidden");
	$("#footer").addClass("hidden");
	$("#main").addClass("full");
	$("#enterFullscreen").hide();
	$("#exitFullscreen").show();
	// hiding, then showing the entire wrapper seems to force the page to redraw
	$(".wrapper").hide(10, function(){$(".wrapper").show()});


	return false;
}

function exitFullscreen()
{
	$("#header").removeClass("hidden");
	$("#footer").removeClass("hidden");
	$("#main").removeClass("full");
	$("#enterFullscreen").show();
	$("#exitFullscreen").hide();
	// hiding, then showing the entire wrapper seems to force the page to redraw
	$(".wrapper").hide(10, function(){$(".wrapper").show()});

	return false;
}

function enableKiosk(delayTime)
{
	$("#kiosk_footer").show();
	$("#footer").addClass("kiosk");
	$("#enterFullscreen a").click(fullScreen);
	$("#exitFullscreen a").click(exitFullscreen);

	fullScreen();	

	$("#kioskDelay").text((Math.round(delayTime / 100.0))/10);

	$( "#kiosk_delay_slider" ).slider({
			range: "min",
			value: delayTime,
			min: 3000,
			max: 60000,
			slide: function( event, ui ) {
				var newValue = Math.round(ui.value / 100.0) / 10;
				$( "#kioskDelay" ).text( newValue );
			}
	});
}
window.addEventListener("popstate", function(e) {
  if(location.pathname != "/"){
    var path = location.pathname;
    $.ajax({
      type: "GET",
      url: path,
      dataType: "script"
    });
  }
});
