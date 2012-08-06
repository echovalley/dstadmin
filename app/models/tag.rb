class Tag < ActiveRecord::Base
  attr_accessible :tname
  validates_presence_of :tname
  has_and_belongs_to_many :products

  def self.get_tags(tags)
    arr = tags.split(%r{\s+});
    return [] if arr.blank?

    arr1 = []
    arr.each do |t|
      tag = Tag.find_by_tname(t)
      tag = Tag.create(:tname => t) if tag.blank?
      arr1 << tag
    end
    arr1 
  end

end
