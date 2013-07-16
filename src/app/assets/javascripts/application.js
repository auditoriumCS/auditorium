// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require jquery.expander.min
//= require jquery-migrate-1.1.0.min
//= dontrequire zepto
//= require twitter/bootstrap
//= require ajax
//= require bootstrap
//= require chairs
//= require course_memberships
//= require courses
//= require email_settings
//= require faculties
//= require feedbacks
//= require follow-button
//= require home
//= require ie
//= require events
//= require institutes
//= require jquery.placeholder.min
//= require landing_page
//= require lectures
//= require my_faculties
//= require notifications
//= require periods
//= require posts
//= require search
//= require terms
//= require users
//= require url_helper
//= require_tree ./BOSH
//= require amcs
//= require angular-min



function remove_fields(link) {
  $(link).parent(".fields").children("input[type=hidden]")[0].value = "1";
  $(link).parent(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}