# Health check controller spec for Insoshi
# Asserts that the /health endpoint returns proper status and DB connectivity.
#
# Run: bundle exec rspec spec/controllers/health_controller_spec.rb

require 'spec_helper'

describe HealthController do
  describe "GET show" do
    # When the database is accessible, the health check should return 200
    # with a healthy status.
    it "returns healthy status when DB is connected" do
      # Mock database connectivity
      allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)

      get :show

      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("healthy")
      expect(body["database"]).to eq("connected")
    end

    # When the database is down, the health check should return 503
    # with an unhealthy status.
    it "returns unhealthy status when DB is inaccessible" do
      # Mock database failure
      allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)

      get :show

      expect(response).to have_http_status(503)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("unhealthy")
      expect(body["database"]).to eq("failed")
    end
  end
end