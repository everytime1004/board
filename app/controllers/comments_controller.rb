# encoding: utf-8
class CommentsController < ApplicationController
  def create
  	@comment = Comment.new(params[:comment])

    @comment.update_attributes(author: current_user.name)
  	
  	if @comment.save
  		if Post.find_all_by_id(@comment.post_id).first.category == ("inquiry")
  			send_notification_inquiry(Post.find_by_id(@comment.post_id))
  		else
  			send_notification_new_comment(Post.find_by_id(@comment.post_id).comments)
  		end
  		redirect_to post_path(id: @comment.post_id), notice: 'Comments is added successfully.'
  	else
  		redirect_to post_path(id: @comment.post_id), notice: 'PComments is not added.'
  	end
  end
end
