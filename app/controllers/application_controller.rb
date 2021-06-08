class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ActionController::HttpAuthentication::Token
  protect_from_forgery with: :exception

  def authorization

    @authorized_tenant = Tenant.where(api_key: token_and_options(request)).first
    if @authorized_tenant
      @authorized_tenant.request_count += 1
      @authorized_tenant.save 
    end

    if  @authorized_tenant.nil?
      return render json: {
        status: 300,
        message: "Unauthorized access to this API"
      }, status: 401
    end
  end
end
