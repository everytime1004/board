class Post < ActiveRecord::Base

  attr_accessible :description, :title, :category, :count

  validates :title, :description, :presence => true

  belongs_to :user
end
