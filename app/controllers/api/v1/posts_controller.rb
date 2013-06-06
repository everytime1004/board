# encoding: utf-8
class Api::V1::PostsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!

  def index  
    @posts = Post.find(:all, :conditions => ["category NOT IN (?)", "공지사항"]).reverse
    @notices = Post.find_all_by_category("공지사항")

    @posts = @notices + @posts

    @posts
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

      # @images.each_with_index do |image, index|
      #   File.open("public/uploads/photo_phone/#{params[:post][:title].encoding}_#{@post.id}_image_#{index+1}.jpg", 'wb') do |f|
      #     f.write(image)
      #   end
      # end

      # (@images.count).times.each do |imageNum|
      #   @post.photos.new(image: File.open("public/uploads/photo_phone/#{params[:post][:title].encoding}_#{@post.id}_image_#{imageNum+1}.jpg", 'rb'))
      # end

      if @post.save
        send_notification_new_post(@post.title)
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
             :json => { :success => false,
                        :info => @post.errors,
                        :data => {} }
    end
  end

  def show
    @post = Post.find_all_by_id(params[:id]).first
    @image_dir = []

    if @post.photos != []
      @post.photos.each do |photo|
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
end