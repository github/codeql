require "typhoeus"

# BAD
Typhoeus.get("https://www.example.com", ssl_verifypeer: false) # $ Alert

# BAD
post_options = { body: "some data", ssl_verifypeer: false }
Typhoeus.post("https://www.example.com", post_options) # $ Alert

# GOOD
Typhoeus.get("https://www.example.com")
