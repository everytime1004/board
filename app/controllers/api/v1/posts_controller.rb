# encoding: utf-8
class Api::V1::PostsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!

  def index
    if params[:offset_id]
      # 전달받은 id로부터 하위 10개의 post model을 역순으로 가져옴.
      @offset = params[:offset_id].to_i
    else
      @offset = Post.last.id
    end

    if params[:category]=="sell"
      @posts = Post.find(:all, :conditions => ["category IN (?) OR category IN (?)", "sell", "sellComplete"]).reverse
    else  
      @posts = Post.where(:category => params[:category], :id => [(@offset-9)..(@offset)]).reverse
    end

    if @post != []
      @posts
    else
      render :json => { :success => true,
                        :info => "이 게시물은 글이 없습니다.",
                        :data => {} }
    end
  end

  def index_search
    @posts = Post.find(:all, :conditions => ["category IN (?) AND (title IN (?) OR author IN (?))", params[:post][:category], params[:post][:searching], params[:post][:searching]]).reverse

    if @post != []
      @posts
    else
      render :json => { :success => true,
                        :info => "찾으시는 글이 없습니다.",
                        :data => {} }
    end
  end

  def create
    @images = []
    i = 1
    until i==6 || params[:post]["#{:image}#{i}"] == nil

      @images << Base64.decode64(params[:post]["#{:image}#{i}"])
      i += 1
    end

    @post = current_user.posts.build(title: params[:post][:title], category: params[:post][:category], description: params[:post][:description])
    @post.update_attributes(user_id: current_user.id)
    @post.update_attributes(author: current_user.name)
    
    if @post.save
      ## 여기는 heroku 올리기 전 코드
      @images.each_with_index do |image, index|
        tempFile = Tempfile.new("tempFile")
        tempFile.binmode
        tempFile.write(image)

        uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempFile, :filename => "#{params[:post][:title]}_image_#{index+1}.jpg")
        @post.photos.new(image: uploaded_file)

        tempFile.delete
      end

      if @post.save
        send_notification_new_post(@post)
        @post
      else
        render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => "사진 등록이 실패 했습니다.",
                        :data => {} }
        @post.destroy
      end
    else
      render :status => :unprocessable_entity,
             :json => { :success => true,
                        :info => @post.errors,
                        :data => {} }
    end
  end

  def show
    @post = Post.find_all_by_id(params[:id]).first
    @image_dir = []

    if @post.photos != []
      @post.photos.each do |photo|
        # @image_dir << "http://192.168.200.170:3000#{photo.image}"
        @image_dir << "http://115.68.27.117#{photo.image}"
        # @image_dir << "http://115.68.27.117/uploads/photo/thumb_#{@post.title}_#{@post.id}_image_#{imageNum+1}.jpg"
        # @image_dir << "http://boardgeneration.herokuapp.com/uploads/photo/#{@post.title}_#{@post.id}_image_#{imageNum+1}.jpg"
        # puts "http://192.168.0.74:3000/uploads/photo_phone/#{@post.title}_#{@post.id}_image_#{imageNum+1}.jpg"
        # @image_dir << "http://theeye.pe.kr/attach/1/1181213948.jpg"
      end

      render :json => { :success => true,
                        :info => "",
                        :data => {image: @image_dir} }
    else
      render :json => { :success => true,
                        :info => "이 게시물은 사진이 없습니다.",
                        :data => {} }
    end

  end

  def destroy
    # current_user.posts.find_by_id(params[:id])
    @post = current_user.posts.find_by_id(params[:id])
    @post.destroy

    render :json => { :success => true,
                        :info => "글이 삭제 되었습니다.",
                        :data => {}}
  end

  def show_comments
    @comments = Post.find_all_by_id(params[:id]).first.comments

    if @comments != []
      @comments
      
    else
      render :json => { :success => true,
                        :info => "이 게시물은 댓글이 없습니다.",
                        :data => {} }
    end
  end

  # In progress..
  def search_by_title
    # if params[:id]
    #   # 전달받은 id로부터 하위 10개의 post model을 역순으로 가져옴.
    #   @offset = params[:id].to_i
    # else
    #   @offset = Post.last.id
    # end

    @post = Post.where("title LIKE ?", "%#{params[:title]}%")
    if params[:id]
      @post = @post.where(:id => params[:id])
    end

    if @post != []
      @post

      render :json => { :success => true,
                        :info => "",
                        :post => {post: @post} }
    else
      render :json => { :success => true,
                        :info => "관련된 제목의 글이 없습니다.",
                        :data => {} }
    end

  end


end