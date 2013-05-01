# ecoding: utf-8
class Api::V1::PostsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!

  def index
    @posts = Post.all
  end

  def create
    @image = Base64.decode64(params[:post][:image])
    File.open("public/uploads/photo_phone/#{params[:post][:title]}_image.jpg", 'wb') do |f|
      f.write(@image) 
    end
    @post = current_user.posts.build(title: params[:post][:title], category: params[:post][:category], description: params[:post][:description])
    @post.photos.new(image: File.open("public/uploads/photo_phone/#{params[:post][:title]}_image.jpg", 'rb'))
    @post.update_attributes(user_id: current_user.id)
    
    if @post.save
      send_notification_new_post
      @post
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @post.errors,
                        :data => {} }
    end
  end
end