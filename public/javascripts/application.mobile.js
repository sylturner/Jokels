function setupPage()
{
	$( '#mobile_page' ).live( 'pageinit',function(event){
		currentPage = event.currentTarget;
		
		$(currentPage).find("#vote-up").live("click", function(){
			if ( $(this).hasClass("ui-btn-active") )
				return;
				
			var upvote_path = $("#upvote_path").html();
			
			$.ajax({
			  type: "GET",
			  url: upvote_path,
			  dataType: "script"
			});
		});
			
		$(currentPage).find("#vote-down").live("click", function(){
			if ( $(this).hasClass("ui-btn-active") )
				return;
				
			var downvote_path = $("#downvote_path").html();
			
			$.ajax({
			  type: "GET",
			  url: downvote_path,
			  dataType: "script"
			});
		});
			
		$(currentPage).find("#favorite-button").live("click", function(){
			var favorite_path = $("#favorite_path").html();
			
			$.ajax({
			  type: "GET",
			  url: favorite_path,
			  dataType: "script"
			});
		});

		$.ajax({
			url: '/random_joke_path.json',
			dataType: 'json',
			success: function(data) {
				$(currentPage).find("#random_joke").attr("href",data["joke-path"]);
				$(currentPage).find("#random_joke").off();
			}
		})
	});
}

function setupHeaderMenus()
{
	$("#mobile-signin").live("click", function(){
	$('<div>').simpledialog2({
	    mode: 'button',
	    headerText: 'Sign In',
	    headerClose: true,
	    buttonPrompt: 'Please choose a sign in method:',
	    buttons : {
	      'Twitter': {
	        click: function () { 
	          window.location.href = "/auth/twitter";
	        }
	      },
	      'Facebook': {
	        click: function () { 
	          window.location.href = "/auth/facebook";
	          $('#buttonoutput').text('Cancel');
	        }
	      }
	    }
	  });
	});

	$("#mobile-menu").live("click", function(){
	$('<div>').simpledialog2({
	    mode: 'button',
	    headerText: 'Mobile Menu',
	    headerClose: true,
	    buttons : {
	      'Full Version': {
	        click: function () { 
	          window.location.href = "/full_version";
	        },
	        icon: "home"
	      },
	      'All Jokes': {
	      	click: function () { 
	          window.location.href = "/jokes";
	        },
	        icon: "arrow-r"
	      }
	    }
	  });
	});

	$("#mobile-menu-signed-in").live("click", function(){
	$('<div>').simpledialog2({
	    mode: 'button',
	    headerText: 'Mobile Menu',
	    headerClose: true,
	    buttons : {
	      'Full Version': {
	        click: function () { 
	          window.location.href = "/full_version";
	        },
	        icon: "home"
	      },
	      'All Jokes': {
	      	click: function () { 
	          window.location.href = "/jokes";
	        },
	        icon: "arrow-r"
	      },
	      'Sign Out': {
	      	click: function () { 
	          window.location.href = "/signout";
	        },
	        icon: "delete"
	      }
	    }
	  });
	});
}