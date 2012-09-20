# encoding: utf-8
module UntaggedImagesHelper

  def untagged_image_thumbnail(untagged_image)
    UNTAGGED_IMAGE_THUMBNAIL_URL + untagged_image.id.to_s + '.jpg'
  end

end
