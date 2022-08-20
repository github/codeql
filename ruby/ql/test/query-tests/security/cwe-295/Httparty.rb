require "httparty"

# BAD
HTTParty.get("http://example.com/", verify: false)

# BAD
HTTParty.get("http://example.com/", verify_peer: false)

# BAD
HTTParty.get("http://example.com/", { verify_peer: false })

# BAD
HTTParty.post("http://example.com/", body: "some_data", verify: false)

# BAD
HTTParty.post("http://example.com/", { body: "some_data", verify: false })

# GOOD
HTTParty.get("http://example.com/")

# GOOD
HTTParty.get("http://example.com/", verify: true)

# GOOD
HTTParty.get("http://example.com/", verify_peer: true)

# GOOD
HTTParty.post("http://example.com/", body: "some_data")

# GOOD
HTTParty.post("http://example.com/", body: "some_data", verify: true)

# GOOD
HTTParty.post("http://example.com/", { body: "some_data" })

# GOOD
HTTParty.post("http://example.com/", { body: "some_data", verify: true })