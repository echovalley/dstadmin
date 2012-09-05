# encoding: utf-8
module UsersHelper 

  def nav_signup 
    content_tag :ul do
      p = content_tag(:li, link_to('网站主', signup_users_path), :class => current_page?(:controller => 'users', :action => 'signup') ? 'ui-corner-top ui-tabs-selected' : 'ui-corner-top')
      p << content_tag(:li, link_to('广告主', signup_adv_users_path), :class => current_page?(:controller => 'users', :action => 'signup_adv') ? 'ui-corner-top ui-tabs-selected' : 'ui-corner-top')
    end
  end

  def mail_server(email)
    'http://mail.' + email.split('@').last
  end

end
