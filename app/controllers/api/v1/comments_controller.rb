# encoding: utf-8
class Api::V1::CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  def create
    @comment = Comment.new(params[:comment])
    
    if @comment.save
      if Post.find_by_id(@comment.post_id).category == ("inqury")
        send_notification_inquiry(Post.find_by_id(@comment.post_id))
      else
        send_notification_new_comment(Post.find_by_id(@comment.post_id).comments)
      end
      render :json => { :success => true,
                        :info => "댓글이 추가되었습니다.",
                        :data => {} }
    else
      render :json => { :success => true,
                        :info => "다시 시도해 주세요.",
                        :data => {} }
    end
  end

  def destroy
    @comments = Comment.find(params[:id])
    @comments.destroy

    render :json => { :success => true,
                        :info => "댓글이 삭제 되었습니다.",
                        :data => {} }
  end
end