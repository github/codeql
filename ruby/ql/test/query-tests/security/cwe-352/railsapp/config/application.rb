require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Railsapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # This defaults version does NOT enable CSRF protection by default.
    config.load_defaults 5.1

    # BAD: Disabling forgery protection may open the application to CSRF attacks
    config.action_controller.allow_forgery_protection = false
  end
end
