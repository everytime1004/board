# ecoding: utf-8
class Api::V1::GcmsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  def create
    reg_id = params[:gcm].select{|c| c == "reg_id"}.first.second
    if Gcm.find_by_reg_id(reg_id).blank?
      @gcm = Gcm.new(params[:gcm])
      if @gcm.save
        @gcm
      else
        render :status => 401,
               :json => { :success => false,
                          :info => 'Gcm reg_id not registered, try restart app',
                          :data => {} }
      end
    else
      noty = params[:gcm].select{|c| c == "noty"}.first.second
      userName = params[:gcm].select{|c| c == "userName"}.first.second
      Gcm.find_by_reg_id(params[:gcm].select{|c| c == "reg_id"}.first.second).update_attributes(noty: noty, userName: userName)
      render :status => 200,
               :json => { :success => true,
                          :info => 'Gcm reg_id is updated',
                          :data => {} }
    end
  end
end