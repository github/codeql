def authenticate(uid, password, cert: nil) # $ Sink
  if cert != nil then
    # comparison with hardcoded credential
    return cert == "xwjVWdfzfRlbcgKkbSfG/xSrUeHYqxPgz9WKN3Yow1o=" # $ Alert
  end

  # comparison with hardcoded credential
  uid == 123 and password == "X6BLgRWSAtAWG/GaHS+WGGW2K7zZFTAjJ54fGSudHJk=" # $ Alert
end

# call with hardcoded credential as argument
authenticate(123, "4NQX/CqB5Ae98zFUmwj1DMpF7azshxSvb0Jo4gIFmIQ=") # $ Alert

# call with hardcoded credential as argument
authenticate(456, nil, cert: "WLC17dLQ9P8YlQvqm77qplOMm5pd1q25Q2onWqu78JI=") # $ Alert

# concatenation involving literal
authenticate(789, "pw:" + "ogH6qSYWGdbR/2WOGYa7eZ/tObL+GtqDPx6q37BTTRQ=") # $ Alert

pw_left = "3jOe7sXKX6Tx52qHWUVqh2t9LNsE+ZXFj2qw6asRARTV2deAXFKkMTVOoaFYom1Q" # $ Alert
pw_right = "4fQuzXef4f2yow8KWvIJTA==" # $ Alert
pw = pw_left + pw_right
authenticate(999, pw)

passwd = gets.chomp
# call with hardcoded credential-like value, but not to a potential credential sink (should not be flagged)
authenticate("gowLsSGfPbh/ZS60k+LQQBhcq1tsh/YgbvNmDauQr5Q=", passwd)

module Passwords
  class KnownPasswords
    def include?(passwd) # $ Sink
      passwd == "foo"
    end
  end
end

# Call to object method
Passwords::KnownPasswords.new.include?("kdW/xVhiv6y1fQQNevDpUaq+2rfPKfh+teE/45zS7bc=") # $ Alert

# Call to unrelated method with same name (should not be flagged)
"foobar".include?("foo")

def default_cred(username = "user@test.com", password = "abcdef123456") # $ Alert
  username
end
