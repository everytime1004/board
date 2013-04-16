class Post < ActiveRecord::Base

  attr_accessible :description, :title, :category, :count

  validates :title,:presence => true

  belongs_to :user
end
