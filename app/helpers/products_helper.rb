# encoding: utf-8

module ProductsHelper
  def form_notice(message)
    content_tag(:div, content_tag(:i, message, :class => 'normal'), :class => 'notice_form')
  end

  def product_status(status)
    if status == 1
      '正常'
    else
      '暂停'
    end
  end

  def product_status_with_op(status)
    if status == 1
      p = content_tag(:span, '正常 ')
      p << link_to('设为暂停', update_status_product_path, :class => 'icon_status_play', :remote => true) 
    else
      p = content_tag(:span, '暂停 ')
      p << link_to('设为正常', update_status_product_path, :class => 'icon_status_pause', :remote => true) 
    end
  end

  def product_pricing(pricing)
    if pricing == 1
      'CPC'
    elsif pricing == 2
      'CPA'
    else
      'CPS'
    end
  end

  def product_upper_limit(upper_limit)
    upper_limit > 0 ? upper_limit : '无上限' 
  end

  def render_tags(tags)
    str = '';
    tags.each do |t|
      str += content_tag(:span, t.tname, :class => 'tag')
    end
    str.html_safe
  end

  def render_tags_text(tags)
    arr = []
    tags.each do |t|
      arr << t.tname
    end
    arr.join(' ')
  end

  def product_delivery(delivery_type)
    str_hash = {1 => '所有媒体', 2 => '指定类别', 3 => '指定网站' }
    str_hash[delivery_type]
  end

  def toggle_edit_mode(mode)
    if mode == 'normal'
      link_to '退出编辑', product_path, :remote => true
    else 
      link_to '进行编辑', edit_product_path, :remote => true
    end
  end

end
