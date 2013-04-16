# ecoding: utf-8
class Api::V1::GcmsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  def create
    if Gcm.find_by_reg_id(params[:gcm].first.second).blank?
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
      render :status => 200,
               :json => { :success => true,
                          :info => 'Gcm reg_id alreday registered',
                          :data => {} }
    end
  end
end