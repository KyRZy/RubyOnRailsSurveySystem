class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

	before_filter :set_cache_headers
  
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:login])
		devise_parameter_sanitizer.permit(:account_update, keys: [:login])
	end

	private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
