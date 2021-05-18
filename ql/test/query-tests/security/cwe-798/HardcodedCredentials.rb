def authenticate(uid, password, cert: nil)
  if cert != nil then
    # comparison with hardcoded credential
    return cert == "xwjVWdfzfRlbcgKkbSfG/xSrUeHYqxPgz9WKN3Yow1o="
  end

  # comparison with hardcoded credential
  uid == 123 and password == "X6BLgRWSAtAWG/GaHS+WGGW2K7zZFTAjJ54fGSudHJk="
end

# call with hardcoded credential as argument
authenticate(123, "4NQX/CqB5Ae98zFUmwj1DMpF7azshxSvb0Jo4gIFmIQ=")

# call with hardcoded credential as argument
authenticate(456, nil, cert: "WLC17dLQ9P8YlQvqm77qplOMm5pd1q25Q2onWqu78JI=")

# concatenation involving literal
authenticate(789, "pw:" + "4NQX/CqB5Ae98zFUmwj1DMpF7azshxSvb0Jo4gIFmIQ=")

passwd = gets.chomp
# call with hardcoded credential-like value, but not to a potential credential sink (should not be flagged)
authenticate("gowLsSGfPbh/ZS60k+LQQBhcq1tsh/YgbvNmDauQr5Q=", passwd)
