//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require fartscroll
////= require_self
////= require_directory .
//= require_tree ../../../vendor/assets/javascripts/.
$('#add-joke').on('shown.bs.modal', function() {
  $("#joke_question").focus();
});

$("body").delegate(".reveal-punchline", "click", function() {
  $("#click-for-punchline").hide();
  $("#answer-container").slideDown('fast');
  $("#question").css('cursor', 'default');
  $("#share").delay(750).slideDown('fast');
  $("#refresh-joke").delay(750).slideDown('fast');
  $("#alternate-punchlines-button").delay(750).slideDown('fast');
});

$("body").delegate(".refresh-joke", "click", function() {
});
