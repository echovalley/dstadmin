# encoding: utf-8
module WebsitesHelper

  #adspot.js
  def adspot(wcode, cancel_log = nil)
    p = <<-eos
var _adspot_wb_code = '#{wcode}';
var _adspot_host = 'http://kb.adspot.cn';
    eos

    if cancel_log.present?
      p << <<-eos
var _adspot_cancel_log = true;
    eos
    end

    p<< <<-eos
(function () {
  var spotScript = document.createElement('script');
  spotScript.type = 'text/javascript';
  spotScript.async = true;
  spotScript.src = _adspot_host + '/static/dst.js';
  document.documentElement.getElementsByTagName('HEAD')[0].appendChild(spotScript)
})();
    eos
  end

  def code(wcode)
    p = "<script type='text/javascript'>\n"
    p << adspot(wcode)
    p << "</script>"
  end

  def javascript_code(wcode)
    javascript_tag adspot(wcode) 
  end

  #New website bread crumb: step1, step2, step3
  def new_website_crumb(step = 'step1')
    content_tag(:div, :class => 'add_newsite') do
      a = content_tag(:h3, '添加新的网站')
      a << content_tag(:ol, :class => step) do
        p = content_tag(:li, '1、网站基本信息')
        p << content_tag(:li, '2、验证网站')
        p << content_tag(:li, '3、验证成功')
      end
    end
  end

  #Edit website bread crumb
  def edit_website_crumb
    content_tag(:div, :class => 'add_newsite') do
      a = content_tag(:h3, '修改网站信息')
      a << content_tag(:ol, :class => 'step1') do
        p = content_tag(:li, '网站基本信息')
      end
    end
  end

  def pv_selector
    select_tag('pv', options_for_select([['0-10万', 1], ['10-50万', 2], ['50-100万', 3], ['100万以上', 4]]))
  end

  def pv(id)
    if id == 1
      '0-10万'
    elsif id == 2
      '10-50万'
    elsif id == 3
      '50-100万'
    else
      '100万以上'
    end
  end

  def website_category_selector(website_categories)
    select_tag 'media', options_from_collection_for_select(website_categories, :id, :wcname)
  end

end
