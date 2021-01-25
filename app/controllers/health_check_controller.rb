class HealthCheckController < ApplicationController
  def index
    render json: { message: "application is running" }
  end
end
