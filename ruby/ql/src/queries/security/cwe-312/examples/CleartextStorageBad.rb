class UserSession
  def login(username, password)
    # ...
    logfile = File.open("login_attempts.log")
    logfile.puts "login with password: #{password})"
  end
end
