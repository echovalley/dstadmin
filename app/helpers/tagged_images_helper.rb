# encoding: utf-8
module TaggedImagesHelper
  include ProductsHelper

  def tagged_images_bar(wcode, tagged_images, untagged_images)
    content_tag(:div, :class => 'tabs tab_publish') do
      content_tag(:ul) do
        a = content_tag(:li, :class => current_page?(:controller => 'tagged_images') ? 'ui-corner-top ui-tabs-selected' : 'ui-corner-top') do
          link_to(website_tagged_images_path(wcode)) do
            raw('已加锚点图片' + content_tag(:small, tagged_images))
          end
        end
        a << content_tag(:li, :class => current_page?(:controller => 'tagged_images') ? 'ui-corner-top' : 'ui-corner-top ui-tabs-selected') do
          link_to(website_untagged_images_path(wcode)) do
            raw('未加锚点图片' + content_tag(:small, untagged_images))
          end
        end
      end
    end
  end

  def tagged_images_thumbnail(tagged_image)
    TAGGED_IMAGE_THUMBNAIL_URL + tagged_image.id.to_s + '_350.jpg'
  end

  def default_thumbnail()
    image_path('default_thumb_350.jpg')
  end
end
