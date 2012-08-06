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

$(document).ready(function() {
  $(".pagination a").attr("data-remote", "true");
});

jQuery.validator.setDefaults({  
  onfocusout: false,
  errorElement: "em",
  errorPlacement: function(error, element) {
    error.appendTo(element.parent());
    error.css('margin-left', '10px');
    error.css('background-color', '#00ff00');
  },
});

