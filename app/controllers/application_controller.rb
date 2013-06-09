# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

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

    ## check
    # regIdArray.each do |regID|
    #   puts regID
    # end

  	regIdArray
  end

  ## 새 글이 등록 됐을 때 push
  ## home -> index ( category )
  ## index -> show ( title description post_id )
  def send_notification_new_post(post)
  	gcm = GCM.new("AIzaSyBrSeCokkG3Eqn0I4B9VNAcmPrVjiaGtIE")
    registration_ids = array_regId
    options = {data: {message: "새 글 #{post.title} 등록 되었습니다.", 
    category: post.category, title: post.title, description: post.description, post_id: post.id}, 
    collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

  ## 댓글이 추가 됐을 때 push
  ## params : 글의 모든 댓글
  def send_notification_new_comment(comments)
    users = []
    regIdArray = []
    ## Post 글 주인(Post.find_all_by_id(comments.first.post_id).first)

    if comments != []
      users << User.find_by_id(Post.find_by_id(comments.first.post_id).user_id).name

      Gcm.all.each do |gcm|
        comments.each do |comment|
          regIdArray << gcm.reg_id if (gcm.noty == true) && (gcm.user_id == comment.user_id) && regIdArray.index(gcm.reg_id) == nil
        end
      end
    end

    post = Post.find_by_id(comments.first.post_id)

    gcm = GCM.new("AIzaSyBrSeCokkG3Eqn0I4B9VNAcmPrVjiaGtIE")
    registration_ids = regIdArray
    options = {data: {message: "글 #{post.title}에 댓글이 추가됐습니다.", 
    category: post.category, title: post.title, description: post.description, post_id: post.id},
    collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

  def send_notification_sell_complete(comments)
    users = []
    regIdArray = []
    if comments != []
      users << User.find_all_by_id(Post.find_all_by_id(comments.first.post_id).first.user_id).first.name

      Gcm.all.each do |gcm|
        comments.each do |comment|
          regIdArray << gcm.reg_id if (gcm.noty == true) && (gcm.user_id == comment.user_id) && regIdArray.index(gcm.reg_id) == nil
        end
      end
    end

    post = Post.find_by_id(comments.first.post_id)

    gcm = GCM.new("AIzaSyBrSeCokkG3Eqn0I4B9VNAcmPrVjiaGtIE")
    registration_ids = regIdArray
    options = {data: {message: "글 #{post.title}이 판매 완료 되었습니다.",
    category: post.category, title: post.title, description: post.description, post_id: post.id}, 
    collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

  def send_notification_inquiry(post)
    regIdArray = []

    Gcm.all.each do |gcm|
      regIdArray <<  gcm.reg_id if (gcm.noty == true) && (gcm.user_id == post.user_id)
    end

    gcm = GCM.new("AIzaSyBrSeCokkG3Eqn0I4B9VNAcmPrVjiaGtIE")
    registration_ids = regIdArray
    options = {data: {message: "문의하신 글에 댓글이 추가되었습니다.",
    category: post.category, title: post.title, description: post.description, post_id: post.id},
    collapse_key: "updated_posts"}
    response = gcm.send_notification(registration_ids, options)
  end

end