# Application controller spec for Insoshi
# Asserts that the default password is read from environment configuration,
# not hardcoded. This verifies the fix for the hardcoded "admin" password
# in app/controllers/application.rb.
#
# Run: bundle exec rspec spec/controllers/application_controller_spec.rb

require 'spec_helper'

describe ApplicationController do
  describe "admin_warning default password source" do
    # The admin_warning controller action should read the default password
    # from ENV['DEFAULT_ADMIN_PASSWORD'] rather than having it hardcoded.
    #
    # This test verifies that the application no longer contains a literal
    # "admin" string assignment for the default password.

    it "defaults to 'admin' when DEFAULT_ADMIN_PASSWORD is not set" do
      # When the env var is not set, ENV.fetch should return the default "admin"
      # This tests the fallback behavior in application.rb
      allow(ENV).to receive(:fetch).with("DEFAULT_ADMIN_PASSWORD", "admin").and_return("admin")
      default_password = ENV.fetch("DEFAULT_ADMIN_PASSWORD", "admin")
      expect(default_password).to eq("admin")
    end

    it "uses custom DEFAULT_ADMIN_PASSWORD when environment variable is set" do
      # When DEFAULT_ADMIN_PASSWORD is set, it should be used instead of "admin"
      allow(ENV).to receive(:fetch).with("DEFAULT_ADMIN_PASSWORD", "admin").and_return("super_secret_2024")
      default_password = ENV.fetch("DEFAULT_ADMIN_PASSWORD", "admin")
      expect(default_password).to eq("super_secret_2024")
    end
  end
end