class Gcm < ActiveRecord::Base
  attr_accessible :reg_id, :noty

  belongs_to :user
end
