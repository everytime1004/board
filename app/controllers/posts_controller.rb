# encoding: utf-8
class PostsController < ApplicationController
  before_filter :user_session_check, except: :index
  before_filter :user_auth_check, :only => [:new, :edit, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.find(:all, :conditions => ["category NOT IN (?)", "공지사항"])
    @notices = Post.find_all_by_category("공지사항")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @post.increment!(:count)
    @comment = Comment.new
    @comments = Comment.find_all_by_post_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @post.photos.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    if user_signed_in?
      @post = current_user.posts.new(params[:post])
      @post.update_attributes(user_id: current_user.id)

    else
      @post = current_admin.posts.new(params[:post])
    end

    send_notification_new_post

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    if user_signed_in?
      @post = current_user.posts.find(params[:id])
    else
      @post = current_admin.posts.find(params[:id])
    end

    respond_to do |format|
      if @post.update_attributes(params[:post])
        send_notification_sell_complete(@post.comments) if @post.category == "판매 완료"
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
