# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def user_session_check
    unless user_signed_in?
      redirect_to root_path, :notice => "Please Login"
    end
  end

  require 'gcm'

  def array_regId
  	regIdArray = []
  	Gcm.all.each do |gcm|
  		regIdArray << gcm.reg_id
  	end
  	regIdArray
  end

  def send_notification
  	gcm = GCM.new("AIzaSyAFk13f06QBjz_m9VvYatCfZn6sOMnZ6rI")
    registration_ids = array_regId
    options = {data: {posts: "새 글이 등록 되었습니다."}, collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

end
