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
//= require rails
//= require jquery.tools.min
//= require bootstrap.min
//= require jquery.validate.min
//= require messages_cn
//= require jquery.flot
//= require jquery.flot.time

$(document).ready(function() {
  $('.pagination a').attr('data-remote', 'true');
});

jQuery.validator.setDefaults({
  //onfocusout: false,
  errorElement: 'i',
  errorPlacement: function(error, element) {
    var noticeform = element.closest('li').children('.notice_form');
    noticeform.children(":not(.normal)").remove();
    noticeform.append(error);
  },
  errorClass: 'wrong',
  success: function(label) {
    label.removeClass("wrong").addClass("right");
  }
});

jQuery.validator.addMethod("domain", function(value, element) { 
  return this.optional(element) || /^(\w+[\w-\.]+\.[a-zA-Z]+)$/.test(value); 
}, "请填入域名，比如abc.com，www.abc.com");

