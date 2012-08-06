# encoding: utf-8

module ApplicationHelper
  def top_menu
=begin 
    if session[:curadv].present?
      str += content_tag(:li, :class => 'tag')
      content_tag(:li, link_to '我的首页', '/advertiser' %></li>
          <li><%= link_to '我的产品', '/products', :class => 'nav_ad_select' %></li>
          <li><%= link_to '我的图片', '/' %></li>
          <li><%= link_to '怎么使用', '/' %></li>
      p = content_tag(:span, '正常 ')
      p << link_to('设为暂停', update_status_product_path, :class => 'icon_status_play', :remote => true) 
    else
      p = content_tag(:span, '暂停 ')
      p << link_to('设为正常', update_status_product_path, :class => 'icon_status_pause', :remote => true) 
    end
=end
  end

end
