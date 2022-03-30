Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # BAD: Disabling forgery protection may open the application to CSRF attacks
  config.action_controller.allow_forgery_protection = false
end
