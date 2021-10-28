require "faraday"

# BAD
connection = Faraday.new("http://example.com", ssl: { verify: false })
response = connection.get("/")

# BAD
connection = Faraday.new("http://example.com", ssl: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
response = connection.get("/")

# GOOD
connection = Faraday.new("http://example.com")
response = connection.get("/")

# GOOD
response = Faraday.get("http://example.com")

# GOOD
connection = Faraday.new("http://example.com", ssl: { version: :TLSv1 })
response = connection.get("/")

# GOOD
connection = Faraday.new("http://example.com", ssl: { verify: true })
response = connection.get("/")

# GOOD
connection = Faraday.new("http://example.com", ssl: { verify_mode: OpenSSL::SSL::VERIFY_PEER })
response = connection.get("/")
