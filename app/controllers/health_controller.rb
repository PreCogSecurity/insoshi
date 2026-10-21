# Health check controller for Insoshi
# Returns 200 with basic DB connectivity status when the service is healthy.
# Used by load balancers and orchestration systems to determine instance readiness.
class HealthController < ApplicationController
  def show
    # Check database connectivity
    begin
      connection = ActiveRecord::Base.connection
      db_ok = connection.active?
    rescue => e
      db_ok = false
      @db_error = e.message
    end

    # Build response
    status = db_ok ? 200 : 503
    @db_status = db_ok ? "connected" : "failed"

    render json: {
      status: status == 200 ? "healthy" : "unhealthy",
      database: @db_status,
      environment: Rails.env,
      timestamp: Time.current.iso8601
    }, status: status
  end
end