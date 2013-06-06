class Comment < ActiveRecord::Base
  attr_accessible :contents, :user_id, :post_id, :author

  belongs_to :user
  belongs_to :post
end
