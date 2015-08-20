$( document ).ready(function() {
	  $("#faqsParticipation").hide();
	  $("#faqsDonate").hide();
	  $("#faqsVolunteer").hide();
	  $("#submitQuestionInfo").hide();
	});
  
  $('a.faqCategory').click(function() {
	  var id = $(this).attr('href');
	  if(id == "#faqsEvents") {
		  $("#faqsEvents").show();
		  $("#faqsParticipation").hide();
		  $("#faqsDonate").hide();
		  $("#faqsVolunteer").hide();
	  }
	  else 	  if(id == "#faqsDonate") {
		  $("#faqsEvents").hide();
		  $("#faqsParticipation").hide();
		  $("#faqsDonate").show();
		  $("#faqsVolunteer").hide();
	  }
	  else 	  if(id == "#faqsVolunteer") {
		  $("#faqsEvents").hide();
		  $("#faqsParticipation").hide();
		  $("#faqsDonate").hide();
		  $("#faqsVolunteer").show();
	  }
	  else 	  if(id == "#faqsParticipation") {
		  $("#faqsEvents").hide();
		  $("#faqsParticipation").show();
		  $("#faqsDonate").hide();
		  $("#faqsVolunteer").hide();
	  }
	});
  $('a').click(function(e) {
	  var panelBody = $(this).parent().parent().attr('id');
	  if(panelBody) {
		$('#emailTo').val($(this).text());
	  	$('#subject').val($.trim($('a[href*='+ panelBody + ']').text()));
	  	$('#submitQuestionInfo').show();
	  	$('#email').focus();
	  }
	});