class Post < ActiveRecord::Base
  attr_accessible :description, :title, :category, :count, :photos_attributes, :user_id

  validates :title,:presence => true

  belongs_to :postable, polymorphic: true

  has_many :photos, as: :photoable

  accepts_nested_attributes_for :photos
end
