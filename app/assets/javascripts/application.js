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
//= require jquery.min
//= require rails
//= require jquery.tools.min
//= require bootstrap.min
//= require jquery.validate.min
//= require messages_cn
//= require jquery.flot
//= require jquery.flot.time

$(document).ready(function() {
  $('.pagination a').attr('data-remote', 'true');

  $('li input').focus(function() {
    var noticeform = $(this).closest('li').children('.notice_form');
    noticeform.children(":not(.normal)").remove();
    noticeform.children(".normal").show();
  });

  //Modal+Ajax form
  $('[data-toggle="modal"]').live('click', function(e) {
    e.preventDefault();
    var url = $(this).attr('href');
    var _top = $(document).scrollTop();
    if (url.indexOf('#') == 0) {
      $(url).modal('open');
    } else {
      $.get(url, function(data) {
        $('.modal').remove();
        $(data).filter('.modal').modal();
        $('.modal input:text:visible:first').focus();
        $(document).scrollTop(_top);
        var js = $(data).filter('script');
        if (js) {
          setTimeout(function(){ $(document).append(js); }, 500);
        }
      });
    }
  });

  $('[data-dismiss="modal"]').live('click', function(e) {
    e.preventDefault();
    setTimeout(function(){
      $('.modal-backdrop').remove();
    }, 300);
  });
});

jQuery.validator.setDefaults({
  //onfocusout: false,
  errorElement: 'i',
  errorPlacement: function(error, element) {
    var noticeform = element.closest('li').children('.notice_form');
    noticeform.css('visibility', 'visible');
    noticeform.children(":not(.normal)").remove();
    noticeform.children(".normal").hide();
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

