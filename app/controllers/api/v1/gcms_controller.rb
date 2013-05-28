# encoding: utf-8
class Api::V1::GcmsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  def create
    reg_id = params[:gcm].select{|c| c == "reg_id"}.first.second
    current_user = User.find_by_name(params[:gcm].select{|c| c == "userName"}.first.second)
    
    @gcm = current_user.build_gcm(reg_id: params[:gcm].select{|c| c == "reg_id"}.first.second, noty: params[:gcm].select{|c| c == "noty"}.first.second)
    
    if @gcm.save
      @gcm
    else
      render :status => 401,
             :json => { :success => false,
                        :info => '서버에 GCM이 등록되지 않았습니다. 다시 시도 해주세요.',
                        :data => {} }
    end
  end
end