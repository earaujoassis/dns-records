class ApplicationController < ActionController::API
  rescue_from Exception,
    :with => :render_error_response

  def render_error_response(error)
    render json: { errors: error }, status: 500
  end
end
