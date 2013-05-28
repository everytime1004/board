# encoding: utf-8
class Api::V1::GcmsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  def create
    reg_id = params[:gcm].select{|c| c == "reg_id"}.first.second
    current_user = User.find_by_name(params[:gcm].select{|c| c == "userName"}.first.second)
    puts reg_id
    if !Gcm.find_by_reg_id(reg_id)
      @gcm = current_user.build_gcm(reg_id: params[:gcm].select{|c| c == "reg_id"}.first.second, noty: params[:gcm].select{|c| c == "noty"}.first.second)
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
      current_user.gcm.update_attributes(noty: noty)
      # Gcm.find_by_reg_id(params[:gcm].select{|c| c == "reg_id"}.first.second).update_attributes(noty: noty)
      render :status => 200,
               :json => { :success => true,
                          :info => 'Gcm reg_id is updated',
                          :data => {} }
    end
  end
end