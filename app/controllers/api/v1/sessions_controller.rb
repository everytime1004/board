# encoding: utf-8
class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :status => 200,
           :json => { :success => true,
                      :info => "로그인 되셨습니다.",
                      :data => { :auth_token => current_user.authentication_token } }
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "로그아웃 되셨습니다.",
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "로그인 실패. 다시 시도해 주세요.",
                      :data => {} }
  end
end