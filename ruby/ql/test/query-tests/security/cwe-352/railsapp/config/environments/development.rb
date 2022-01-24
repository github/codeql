Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # GOOD: disabling CSRF protection in the development environment should not be flagged
  config.action_controller.allow_forgery_protection = false
end
