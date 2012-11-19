# encoding: utf-8
module ApplicationHelper

  def form_notice(message)
    content_tag(:div, content_tag(:i, message, :class => 'normal'), :class => 'notice_form')
  end

  def top_menu
    if session[:curadv].present?
      p = content_tag(:li, link_to('我的首页', dashboard_advertiser_path), :class => current_page?(:controller => 'advertisers', :action => 'dashboard') ? 'nav_ad_select' : nil)
      p << content_tag(:li, link_to('我的产品', products_path), :class => (params[:controller] == 'products') ? 'nav_ad_select' : nil)
      #p << content_tag(:li, link_to('我的图片', '#'))
      #p << content_tag(:li, link_to('怎么使用', '#'))
    else
    end
  end

  def login_crumb
    email = session[:user_email]
    user_code = session[:user]
    if email.present?
      p = link_to '修改密码', { :action => 'change_password', :controller => 'users', :id => user_code }, :class => 'noborderleft'
      #p += link_to '消 息', '#'
      p += link_to '我的所有网站', websites_path if session[:curadv].blank?
      p += link_to '登 出', signout_users_path
    else
      p = link_to '免费注册', signup_users_path, :class => 'btn_green size-m'
      p += link_to '登 入', signin_users_path
    end
  end

  def notice_div(display = false)
    content_tag :div, :class => 'alert', :style => display ? nil : 'display:none' do
      p = content_tag :button, 'x', :class => 'close', :'data-dismiss' => 'alert'
      p += content_tag :h3, nil, :id => 'notice', :class => 'acenter'
    end
  end

  def notice_javascript
    return nil unless flash.present?
    javascript_tag do
      "
      $(document).ready(function() {
        var msg_success = '#{flash[:success]}';
        var msg_error = '#{flash[:error]}';
        var msg_info = '#{flash[:info]}';
        var msg_warning = '#{flash[:warning]}';
        if (msg_success) {
          $('#notice').text(msg_success);
          $('.alert').addClass('alert-success').fadeIn(200);
        } else if (msg_error) {
          $('#notice').text(msg_error);
          $('.alert').addClass('alert-error').fadeIn(200);
        } else if (msg_info) {
          $('#notice').text(msg_info);
          $('.alert').addClass('alert-info').fadeIn(200);
        } else {
          $('#notice').text(msg_warning);
          $('.alert').fadeIn(200);
        }
      });
      ".html_safe
    end
  end

  def number_format(number)
    return number.blank? ? '-' : number
  end

end
