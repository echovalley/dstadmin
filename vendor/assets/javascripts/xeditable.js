(function($) {
  $.fn.editable = function(target) {
    var _self = $(this);

    function show_edit_box() {
      _self.hide();
      $('.icon_edit').hide();
      $('.editable_box').show();
      $('.editable_box input').val(_self.text());
      $('.editable_box input').focus();
    }

    function cancel_edit() {
      _self.show();
      $('.icon_edit').show();
      $('.editable_box input').val(_self.text());
      $('.editable_box').siblings('.alert').remove();
      $('.editable_box').hide();
    }

    function submit_edit_box() {
      var newval = $('.editable_box input').val();
      if (newval == '') return;
      cancel_edit();
      var submit_url = target + '?' + _self.attr('name') + '=' + encodeURIComponent(newval);
      $.get(submit_url, function(returnval) {
        var label_succ = '<div class="alert alert-success"><button data-dismiss="alert" class="close">x</button><h5 id="notice" class="acenter">成功修改</h5></div>';
        var label_fail = '<div class="alert alert-error"><button data-dismiss="alert" class="close">x</button><h5 id="notice" class="acenter">修改失败</h5></div>';
        if (returnval == 1) {
          _self.closest('div').prepend(label_succ);
          _self.text(newval);
        } else {
		  _self.closest('div').prepend(label_fail);
        }
      });
    }

    var box_html = '<span class="editable_box" style="display:none"><input type="text" name="value" autocomplete="off" style="width: 200px; height: 20px; padding:2px"><button class="editable_submit">修改</button><button class="editable_cancel">取消</button></span><a href="javascript:void(0)" class="icon_edit">编 辑</a>';
    _self.after(box_html);

    $('.icon_edit').click(function(e) {
      e.stopPropagation();
      show_edit_box();
    });

    $('.editable_submit').click(function() {
      submit_edit_box();
    });

    $('.editable_cancel').click(function() {
      cancel_edit();
    });

    $('.editable_box').keydown(function(e) {
      if (e.keyCode == 27) {
        e.preventDefault();
        cancel_edit();
      } else if (e.keyCode == 13) {
        e.preventDefault();
        submit_edit_box();
      }
    });
  };

})(jQuery);
