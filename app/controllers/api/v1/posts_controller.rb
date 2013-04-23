# ecoding: utf-8
class Api::V1::PostsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!

  def index
    @posts = Post.all
  end

  def create
    @post = current_user.posts.build(params[:post])
    @post.update_attributes(user_id: current_user.id)
    
    if @post.save
      @post
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @post.errors,
                        :data => {} }
    end
  end
end