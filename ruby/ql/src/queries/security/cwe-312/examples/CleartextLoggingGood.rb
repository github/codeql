require 'Logger'

class UserSession
  @@logger = Logger.new STDOUT

  def login(username, password)
    # ...
    password_escaped = password.sub(/.*/, "[redacted]")
    @@logger.info "login with password: #{password_escaped})"
  end
end
