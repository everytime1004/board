# encoding: utf-8
class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, :if => Proc.new{ |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    build_resource
    if resource.save
      sign_in resource
      render :status => 200,
           :json => { :success => true,
                      :info => "회원가입이 되었습니다. 환영합니다!",
                      :data => { :user => resource,
                                 :auth_token => current_user.authentication_token,
                                 :user_id => current_user.id } }
    else
      render :status => 200,
             :json => { :success => false,
                        :info => resource.errors,
                        :data => { }
                      }
    end
  end
end