# encoding: utf-8
class Post < ActiveRecord::Base
  attr_accessible :description, :title, :category, :count, :photos_attributes, :user_id, :comments_attributes, :author

  validates :title,:presence => true

  belongs_to :postable, polymorphic: true

  has_many :photos, as: :photoable, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :comments
end
