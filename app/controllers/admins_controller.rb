# encoding: utf-8
class AdminsController < Devise::SessionsController
	def after_sign_in_path_for(resource)
	  admins_path
	end

  def index
    
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  def show_posts
  	@posts = Post.find(:all, :conditions => ["category NOT IN (?)", "공지사항"])
    @notices = Post.find_all_by_category("공지사항")
  end

end