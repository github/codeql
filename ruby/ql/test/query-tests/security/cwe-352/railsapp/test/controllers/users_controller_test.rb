require "test_helper"

class UsersControllerTest < ActiveSupport::TestCase
  setup do
    # GOOD: disabling CSRF protection in tests should not be flagged
    config.action_controller.allow_forgery_protection = false
  end
end
