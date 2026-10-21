# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use tagged logging with request ID for structured log correlation
config.logger = ActiveSupport::TaggedLogger.new(config.logger)

# Request ID middleware - generates a unique request ID for each request
# if one is not already set (e.g., via X-Request-ID header)
config.action_dispatch.request_id = ->(env) { env["action_dispatch.request_id"] ||= SecureRandom.hex(8) }

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
