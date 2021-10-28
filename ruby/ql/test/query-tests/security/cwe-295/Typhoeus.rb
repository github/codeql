require "typhoeus"

# BAD
Typhoeus.get("https://www.example.com", ssl_verifypeer: false)

# BAD
post_options = { body: "some data", ssl_verifypeer: false }
Typhoeus.post("https://www.example.com", post_options)

# GOOD
Typhoeus.get("https://www.example.com")