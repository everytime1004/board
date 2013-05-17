# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def user_session_check
    unless user_signed_in? || admin_signed_in?
      redirect_to root_path, :notice => "Please Login"
    end
  end

  def user_auth_check
    if user_signed_in?
      authenticate_user!
    else
      authenticate_admin!
    end
  end

  require 'gcm'

  def array_regId
  	regIdArray = []
  	Gcm.all.each do |gcm|
  		regIdArray << gcm.reg_id if gcm.noty == true
  	end
  	regIdArray
  end

  def send_notification_new_post
  	gcm = GCM.new("AIzaSyBrSeCokkG3Eqn0I4B9VNAcmPrVjiaGtIE")
    registration_ids = array_regId
    options = {data: {posts: "새 글이 등록 되었습니다."}, collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

  def send_notification_new_comment(comments)
    users = []
    regIdArray = []
    users << User.find_all_by_id(comments.first.user_id).first.name
    comments.each do |comment|
      users << User.find_all_by_id(comment.user_id).first.name
    end
    Gcm.all.each do |gcm|
      users.each do |user|
        regIdArray << gcm.reg_id if gcm.userName == user && gcm.noty == true
      end
    end

    gcm = GCM.new("AIzaSyAFk13f06QBjz_m9VvYatCfZn6sOMnZ6rI")
    registration_ids = array_regId
    options = {data: {posts: "글에 댓글이 추가됐습니다."}, collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

  def send_notification_sell_complete(comments)
    users = []
    regIdArray = []
    if comments != []
      title = (Post.find_all_by_id(comments.first.post_id).first.user_id).first.title
    end

    comments.each do |comment|
      users << User.find_all_by_id(comment.user_id).first.name
    end
    Gcm.all.each do |gcm|
      users.each do |user|
        regIdArray << gcm.reg_id if gcm.userName == user && gcm.noty == true
      end
    end

    gcm = GCM.new("AIzaSyAFk13f06QBjz_m9VvYatCfZn6sOMnZ6rI")
    registration_ids = array_regId
    options = {data: {posts: "글 #{title}이 판매 완료 되었습니다."}, collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

  def send_notification_inquiry(user_id)
    user = User.find_all_by_id(user_id).first.name

    Gcm.all.each do |gcm|
      regIdArray = gcm.reg_id if gcm.userName == user && gcm.noty == true
    end

    gcm = GCM.new("AIzaSyAFk13f06QBjz_m9VvYatCfZn6sOMnZ6rI")
    registration_ids = array_regId
    options = {data: {posts: "문의하신 글에 댓글이 추가되었습니다."}, collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)

  end

end
