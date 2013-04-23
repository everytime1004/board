class Photo < ActiveRecord::Base
  attr_accessible :image
  belongs_to :photoable, polymorphic: true

  mount_uploader :image, ImageUploader
end
