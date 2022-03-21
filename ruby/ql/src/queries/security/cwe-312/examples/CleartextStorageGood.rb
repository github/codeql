class UserSession
  def login(username, password)
    # ...
    password_escaped = password.sub(/.*/, "[redacted]")
    logfile = File.open("login_attempts.log")
    logfile.puts "login with password: #{password_escaped})"
  end
end
